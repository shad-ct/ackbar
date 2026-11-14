#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Ensure shared files are synced
"${SCRIPT_DIR}/sync-shared.sh"

WIDGETS=("quick-capture" "habit-tracker" "random-challenge" "task-goal-manager" "timetrack-widget")
TARGET_WIDGETS=("${@:-${WIDGETS[@]}}")

echo "=============================================="
echo "  KDE Productivity Suite — Installer"
echo "=============================================="

for widget in "${TARGET_WIDGETS[@]}"; do
    widget_dir="${ROOT_DIR}/${widget}"
    if [ ! -d "${widget_dir}" ]; then
        echo "Error: Widget directory not found: ${widget_dir}"
        continue
    fi

    metadata_file="${widget_dir}/metadata.json"
    if [ ! -f "${metadata_file}" ]; then
        echo "Error: metadata.json not found in ${widget_dir}"
        continue
    fi

    plugin_id=$(python3 -c "import json; print(json.load(open('${metadata_file}'))['KPlugin']['Id'])")
    plugin_name=$(python3 -c "import json; print(json.load(open('${metadata_file}'))['KPlugin']['Name'])")

    echo ""
    echo "Processing: ${plugin_name} (${plugin_id})"

    # Check if currently installed
    if kpackagetool6 --type Plasma/Applet --list | grep -q "${plugin_id}"; then
        echo "  Existing installation detected. Upgrading..."
        kpackagetool6 --type Plasma/Applet --upgrade "${widget_dir}"
        echo "  ✓ Upgraded successfully."
    else
        echo "  Installing new widget..."
        kpackagetool6 --type Plasma/Applet --install "${widget_dir}"
        echo "  ✓ Installed successfully."
    fi
done

echo ""
echo "=============================================="
echo "Installation complete!"
echo "You can now add the widgets to your desktop or panel via the 'Add Widgets' menu."
echo "=============================================="

