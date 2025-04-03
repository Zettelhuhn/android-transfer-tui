#!/bin/bash

export LANG=de_DE.UTF-8
echo "📱 Android Transfer TUI"
echo "------------------------"

# 🔌 Android-Geräte prüfen
adb devices

# 📂 Android-Ordner unter /sdcard/
ORDNER_LISTE=$(adb shell ls -d /sdcard/*/ 2>/dev/null | tr -d '\r')
TMP_ANDROID=$(mktemp)

while read -r ordner; do
  name=$(basename "$ordner")
  echo "\"$ordner\" \"$name\"" >> "$TMP_ANDROID"
done <<< "$ORDNER_LISTE"

SRC=$(eval dialog --clear --stdout \
  --title \"📂 Android-Ordner auswählen\" \
  --menu \"Wähle einen Ordner unter /sdcard aus:\" 20 60 12 \
  $(cat "$TMP_ANDROID"))
rm -f "$TMP_ANDROID"

[ -z "$SRC" ] && echo "🚫 Abbruch – kein Android-Ordner gewählt." && exit 1

# 💾 Schritt 1: Volume auswählen
TMP_VOLUME=$(mktemp)
for mount in /Volumes/*; do
  [ -d "$mount" ] && name=$(basename "$mount") && echo "\"$mount\" \"$name\"" >> "$TMP_VOLUME"
done

DEST_BASE=$(eval dialog --clear --stdout \
  --title \"💾 Zielvolume auswählen\" \
  --menu \"Wähle ein Zielvolume unter /Volumes:\" 15 60 8 \
  $(cat "$TMP_VOLUME"))
rm -f "$TMP_VOLUME"

[ -z "$DEST_BASE" ] && echo "🚫 Abbruch – kein Volume gewählt." && exit 1

# 💾 Schritt 2: Ordner im gewählten Volume auflisten (nur 1 Ebene tief)
TMP_SUB=$(mktemp)
for path in "$DEST_BASE"/*/; do
  [ -d "$path" ] && name=$(basename "$path") && echo "\"$path\" \"$name\"" >> "$TMP_SUB"
done

DEST=$(eval dialog --clear --stdout \
  --title \"📁 Zielordner wählen\" \
  --menu \"Wähle einen Ziel-Unterordner auf $DEST_BASE:\" 20 60 10 \
  $(cat "$TMP_SUB"))
rm -f "$TMP_SUB"

[ -z "$DEST" ] && echo "🚫 Abbruch – kein Zielordner gewählt." && exit 1

# ✅ Bestätigung vor dem Kopieren
dialog --yesno "Willst du wirklich kopieren?\n\nVon:\n$SRC\n\nNach:\n$DEST" 12 60
KOPIEREN_OK=$?

[ "$KOPIEREN_OK" -ne 0 ] && echo "🚫 Kopiervorgang abgebrochen." && exit 1

# 📄 Inhalt anzeigen
echo ""
echo "📄 Inhalt von $SRC:"
adb shell ls "$SRC"

# 🔄 Kopieren
echo ""
echo "🔄 Kopiervorgang läuft..."
adb pull -a "$SRC" "$DEST"

# ✅ Abschluss
echo ""
echo "✅ Übertragung abgeschlossen!"
