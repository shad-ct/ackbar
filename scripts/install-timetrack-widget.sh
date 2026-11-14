#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
WIDGET_DIR="${ROOT_DIR}/timetrack-widget"
PLUGIN_ID="org.kde.plasma.timetrackanalytics"
INSTALL_PATH="${HOME}/.local/share/plasma/plasmoids/${PLUGIN_ID}"

echo "=============================================="
echo "  Installing TimeTrack Analytics Widget"
echo "=============================================="

if kpackagetool6 --type Plasma/Applet --list | grep -q "${PLUGIN_ID}"; then
    echo "Existing installation found. Upgrading..."
    kpackagetool6 --type Plasma/Applet --upgrade "${WIDGET_DIR}" || {
        echo "Fallback to manual directory copy..."
        rm -rf "${INSTALL_PATH}"
        mkdir -p "${INSTALL_PATH}"
        cp -r "${WIDGET_DIR}"/* "${INSTALL_PATH}/"
    }
else
    echo "Installing new widget..."
    kpackagetool6 --type Plasma/Applet --install "${WIDGET_DIR}" || {
        echo "Fallback to manual directory copy..."
        mkdir -p "${INSTALL_PATH}"
        cp -r "${WIDGET_DIR}"/* "${INSTALL_PATH}/"
    }
fi

echo "✓ TimeTrack Analytics widget installed successfully!"

