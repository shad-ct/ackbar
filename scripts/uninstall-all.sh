#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

WIDGETS=("quick-capture" "habit-tracker" "random-challenge" "task-goal-manager" "timetrack-widget")
TARGET_WIDGETS=("${@:-${WIDGETS[@]}}")

echo "=============================================="
echo "  KDE Productivity Suite — Uninstaller"
echo "=============================================="

for widget in "${TARGET_WIDGETS[@]}"; do
    widget_dir="${ROOT_DIR}/${widget}"
    metadata_file="${widget_dir}/metadata.json"

    if [ -f "${metadata_file}" ]; then
        plugin_id=$(python3 -c "import json; print(json.load(open('${metadata_file}'))['KPlugin']['Id'])")
    else
        plugin_id="${widget}"
    fi

    echo ""
    echo "Checking status for: ${plugin_id}"

    if kpackagetool6 --type Plasma/Applet --list | grep -q "${plugin_id}"; then
        echo "  Removing ${plugin_id}..."
        kpackagetool6 --type Plasma/Applet --remove "${plugin_id}"
        echo "  ✓ Removed successfully."
    else
        echo "  Not currently installed. Skipping."
    fi
done

echo ""
echo "=============================================="
echo "Uninstallation complete."
echo "=============================================="

