#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
DIST_DIR="${ROOT_DIR}/dist"

# Ensure shared components are in sync
"${SCRIPT_DIR}/sync-shared.sh"

mkdir -p "${DIST_DIR}"
rm -f "${DIST_DIR}"/*.plasmoid

WIDGETS=("quick-capture" "habit-tracker" "random-challenge" "task-goal-manager" "timetrack-widget")

echo "Packaging all widgets into ${DIST_DIR}..."

for widget in "${WIDGETS[@]}"; do
    widget_dir="${ROOT_DIR}/${widget}"
    metadata_file="${widget_dir}/metadata.json"

    if [ ! -f "${metadata_file}" ]; then
        echo "Skipping ${widget} (metadata.json not found)"
        continue
    fi

    plugin_id=$(python3 -c "import json; print(json.load(open('${metadata_file}'))['KPlugin']['Id'])")
    version=$(python3 -c "import json; print(json.load(open('${metadata_file}'))['KPlugin'].get('Version', '1.0.0'))")
    output_pkg="${DIST_DIR}/${plugin_id}-${version}.plasmoid"

    echo "  Packaging ${plugin_id} -> $(basename "${output_pkg}")"
    (
        cd "${widget_dir}"
        zip -rq "${output_pkg}" metadata.json contents/
    )
    echo "  ✓ Created $(basename "${output_pkg}")"
done

echo "Packaging completed successfully."

