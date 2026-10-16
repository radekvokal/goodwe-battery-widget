#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing GoodWe Battery Widget for KDE Plasma 6..."

# Install Python dependency
echo "Installing Python dependency (goodwe)..."
python3 -m pip install --user goodwe

# Install the helper script
echo "Installing helper script to ~/.local/bin/..."
mkdir -p ~/.local/bin
cp "$SCRIPT_DIR/scripts/goodwe-battery-status.py" ~/.local/bin/goodwe-battery-status
chmod +x ~/.local/bin/goodwe-battery-status

# Install the plasmoid
echo "Installing Plasma widget..."
if kpackagetool6 --list --type Plasma/Applet 2>/dev/null | grep -q "org.goodwe.battery"; then
    kpackagetool6 --upgrade "$SCRIPT_DIR/plasmoid" --type Plasma/Applet
else
    kpackagetool6 --install "$SCRIPT_DIR/plasmoid" --type Plasma/Applet
fi

echo ""
echo "Installation complete!"
echo "You can now add the 'GoodWe Battery' widget to your desktop:"
echo "  Right-click desktop -> Add Widgets -> search 'GoodWe'"
echo ""
echo "Configure the inverter IP by right-clicking the widget -> Configure..."
