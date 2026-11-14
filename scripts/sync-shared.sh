#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

WIDGETS=("quick-capture" "habit-tracker" "random-challenge" "task-goal-manager")

echo "Syncing shared components to all widgets..."

for widget in "${WIDGETS[@]}"; do
    target_ui="${ROOT_DIR}/${widget}/contents/ui/shared"
    target_js="${ROOT_DIR}/${widget}/contents/js/shared"

    mkdir -p "${target_ui}" "${target_js}"

    # Sync UI components and tokens
    cp -u "${ROOT_DIR}"/shared/theme/*.qml "${target_ui}/" 2>/dev/null || cp "${ROOT_DIR}"/shared/theme/*.qml "${target_ui}/"
    cp -u "${ROOT_DIR}"/shared/components/*.qml "${target_ui}/" 2>/dev/null || cp "${ROOT_DIR}"/shared/components/*.qml "${target_ui}/"

    # Sync utilities
    cp -u "${ROOT_DIR}"/shared/utilities/*.js "${target_js}/" 2>/dev/null || cp "${ROOT_DIR}"/shared/utilities/*.js "${target_js}/"

    echo "  -> Synced to ${widget}"
done

echo "Shared components synced successfully."

