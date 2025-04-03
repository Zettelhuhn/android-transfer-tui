#!/bin/bash

# Android Transfer TUI – erste Version

echo "📱 Android Transfer TUI"
echo "------------------------"

# Zeige verbundene Geräte
adb devices

# Zeige Inhalt des Kamera-Ordners
echo ""
echo "Inhalt von /sdcard/DCIM/Camera:"
adb shell ls /sdcard/DCIM/Camera
