# android-transfer-tui

TUI-Tool für ADB-Datentransfer zwischen Android und Mac/Linux – komplett offline und ohne Cloud oder Drittanbieter-Apps.  
Funktioniert direkt über das Terminal mit klarer Menüführung dank `dialog`.

---

## 🔁 Skripte

### `android-transfer-mac.sh`  
⬇️ **Android → Mac**

- Zeigt eine Liste von Ordnern auf dem Android-Gerät (unter `/sdcard`)
- Auswahl erfolgt über TUI-Menü (`dialog`)
- Zielordner am Mac wird über GUI (`osascript`) gewählt
- Übertragung erfolgt per `adb pull`

---

### `mac-transfer-android.sh`  
⬆️ **Mac → Android**

- Lokaler Ordner auf dem Mac wird per GUI ausgewählt
- Zielordner auf dem Android-Gerät kann gewählt werden:
  - `/sdcard` direkt
  - Oder einer der vorhandenen Ordner unterhalb von `/sdcard`
- Der gewählte Mac-Ordner wird als gleichnamiger Unterordner auf Android kopiert  
  z. B. `~/Bilder_2024` → `/sdcard/Download/Bilder_2024`
- Übertragung erfolgt per `adb push`

---

## ⚙️ Voraussetzungen

- [`adb`](https://developer.android.com/tools/adb)
- `dialog` (für die TUI-Menüs)

### Installation von `dialog` auf macOS:
```bash
brew install dialog
```