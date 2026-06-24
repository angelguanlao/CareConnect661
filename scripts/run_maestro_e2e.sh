#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v maestro >/dev/null 2>&1; then
  echo "Error: Maestro CLI is not installed."
  echo "Install with: curl -Ls https://get.maestro.mobile.dev | bash"
  exit 1
fi

echo "Running Maestro E2E flows from ${ROOT_DIR}/.maestro"
maestro test "${ROOT_DIR}/.maestro/login_to_dashboard.yaml"
maestro test "${ROOT_DIR}/.maestro/dashboard_to_profile.yaml"
maestro test "${ROOT_DIR}/.maestro/settings_accessibility_preferences.yaml"

echo "Maestro E2E suite completed."
