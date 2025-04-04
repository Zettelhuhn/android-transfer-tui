#!/bin/bash

export LANG=de_DE.UTF-8
echo "⬆️ Mac → Android Transfer TUI"
echo "-----------------------------"

# 🔌 Android-Gerät prüfen
adb devices

# 📁 Lokalen Quellordner wählen (macOS GUI)
SRC=$(osascript <<EOF
set chosenFolder to POSIX path of (choose folder with prompt "Wähle den lokalen Ordner, den du auf Android kopieren möchtest:")
return chosenFolder
EOF
)

[ -z "$SRC" ] && echo "🚫 Abbruch – kein Quellordner gewählt." && exit 1
SRC=${SRC%/}
FOLDERNAME=$(basename "$SRC")

# 📦 dialog prüfen
if ! command -v dialog >/dev/null 2>&1; then
  echo "❗ dialog ist nicht installiert. Installiere es mit:"
  echo "   brew install dialog"
  exit 1
fi

# 📂 Temporäre Menüdatei erstellen
TMPFILE=$(mktemp)

# ➕ Manuelle Option für direkt in /sdcard
echo "/sdcard Direkt_unter_/sdcard/" >> "$TMPFILE"

# 📂 Alle Ordner unter /sdcard auflisten
adb shell "ls -d /sdcard/*/" 2>/dev/null | tr -d '\r' | while read -r dir; do
  name=$(basename "$dir" | tr ' ' '_')
  echo "$dir $name" >> "$TMPFILE"
done

# 📋 Menü anzeigen
DEST_BASE=$(dialog --clear --stdout \
  --title "📂 Zielordner auf Android wählen" \
  --menu "Wähle Ziel für '$FOLDERNAME':" 20 70 15 \
  $(cat "$TMPFILE"))

rm -f "$TMPFILE"

[ -z "$DEST_BASE" ] && echo "🚫 Abbruch – kein Zielordner auf Android gewählt." && exit 1

# 📁 Zielpfad zusammensetzen
DEST="$DEST_BASE/$FOLDERNAME"

# ✅ Bestätigung
dialog --yesno "Willst du wirklich kopieren?\n\nVom Mac:\n$SRC\n\nNach Android:\n$DEST" 12 60
[ $? -ne 0 ] && echo "🚫 Kopiervorgang abgebrochen." && exit 1

# 🔄 Kopieren
echo ""
echo "📤 Kopiere nach: $DEST ..."
adb push "$SRC" "$DEST"

echo ""
echo "✅ Übertragung abgeschlossen!"