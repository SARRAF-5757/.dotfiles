#!/bin/sh
# Environment variables for Fedora Asahi Linux KDE Plasma Wayland session
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM="wayland;xcb"
export ELECTRON_OZONE_PLATFORM_HINT=auto
export GDK_BACKEND="wayland,x11"
export _JAVA_AWT_WM_NONREPARENTING=1
