#!/bin/bash
set -e

echo "Uninstalling GoodWe Battery Widget..."

kpackagetool6 --remove org.goodwe.battery --type Plasma/Applet 2>/dev/null && echo "Widget removed." || echo "Widget was not installed."
rm -f ~/.local/bin/goodwe-battery-status && echo "Helper script removed."

echo "Uninstallation complete."
