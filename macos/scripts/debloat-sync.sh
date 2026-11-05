#!/usr/bin/env bash
# Required parameters for Raycast (optional):
# @raycast.schemaVersion 1
# @raycast.title Debloat Sync
# @raycast.mode fullOutput
# @raycast.icon 🛡️
#
# Documentation:
# @raycast.description Backup or apply macOS debloated launchd services via .dotfiles
# @raycast.author SARRAF

set -euo pipefail

# -----------------------------------------------------------------------------
# Color Codes & Formatting
# -----------------------------------------------------------------------------
BOLD='\033[1m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m'

info()    { echo -e "${CYAN}ℹ${NC} $*"; }
success() { echo -e "${GREEN}✓${NC} $*"; }
error()   { echo -e "${RED}✗${NC} $*" >&2; }
header()  { echo -e "\n${BOLD}${CYAN}==>${NC} ${BOLD}$*${NC}"; }

# -----------------------------------------------------------------------------
# Paths
# -----------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"
PRESET_SRC="${DOTFILES_DIR}/macos/.mac-os-debloat/presets/personal.txt"
TARGET_PRESET_DIR="${HOME}/.mac-os-debloat/presets"
TARGET_PRESET_FILE="${TARGET_PRESET_DIR}/personal.txt"
DEBLOAT_BIN="$(command -v debloat || echo "/opt/homebrew/bin/debloat")"

# -----------------------------------------------------------------------------
# Help Menu
# -----------------------------------------------------------------------------
show_help() {
    echo -e "${BOLD}macOS Debloat Sync Tool (.dotfiles)${NC}

${BOLD}Usage:${NC}
  ./debloat-sync.sh [OPTIONS]

${BOLD}Options:${NC}
  -b, --backup     Save currently disabled launchd services to personal.txt
  -a, --apply      Apply personal.txt preset to the system (sudo required)
  -s, --status     View current debloat status
  -h, --help       Show this help message
"
}

# -----------------------------------------------------------------------------
# Symlink Management
# -----------------------------------------------------------------------------
ensure_symlink() {
    mkdir -p "${TARGET_PRESET_DIR}"
    if [[ ! -L "${TARGET_PRESET_FILE}" || "$(readlink "${TARGET_PRESET_FILE}")" != "${PRESET_SRC}" ]]; then
        ln -sf "${PRESET_SRC}" "${TARGET_PRESET_FILE}"
        success "Linked preset: ${TARGET_PRESET_FILE} -> ${PRESET_SRC}"
    fi
}

# -----------------------------------------------------------------------------
# Action: Backup
# -----------------------------------------------------------------------------
do_backup() {
    header "Backing up Current Debloat State to personal.txt"

    if [[ ! -x "${DEBLOAT_BIN}" ]]; then
        error "debloat executable not found at ${DEBLOAT_BIN}"
        exit 1
    fi

    info "Querying disabled services from system..."
    python3 -c "
import time
from importlib.machinery import SourceFileLoader
from pathlib import Path

mod = SourceFileLoader('debloat', '${DEBLOAT_BIN}').load_module()
sections, note, absent, version_skip = mod.load_sections()
mod.refresh_state(sections)

filtered_sections = []
total_items = 0
for sec in sections:
    disabled_items = [it for it in sec.items if it.disabled]
    if disabled_items:
        new_sec = mod.Section(title=sec.title, preset=sec.preset, macos=sec.macos, items=disabled_items)
        filtered_sections.append(new_sec)
        total_items += len(disabled_items)

out_text = f'''# ==============================================================================
# Personal macOS Debloat Preset
# Updated: {time.strftime('%Y-%m-%d %H:%M:%S')}
# Disabled services: {total_items}
# ==============================================================================

''' + mod.format_labels(filtered_sections)

out_preset = Path('${PRESET_SRC}')
out_preset.parent.mkdir(parents=True, exist_ok=True)
out_preset.write_text(out_text)
print(f'Wrote {total_items} disabled services to {out_preset}')
"
    ensure_symlink
    success "Backup complete! You can now commit personal.txt to your dotfiles."
}

# -----------------------------------------------------------------------------
# Action: Apply / Restore
# -----------------------------------------------------------------------------
do_apply() {
    header "Applying personal.txt Debloat Preset to System"

    if [[ ! -f "${PRESET_SRC}" ]]; then
        error "Preset file not found at ${PRESET_SRC}. Run with --backup first."
        exit 1
    fi

    ensure_symlink

    info "Applying preset via debloat (sudo required)..."
    sudo "${DEBLOAT_BIN}" --preset personal

    success "Preset applied successfully!"
}

# -----------------------------------------------------------------------------
# Action: Status
# -----------------------------------------------------------------------------
do_status() {
    header "Current Debloat Status"
    if [[ -x "${DEBLOAT_BIN}" ]]; then
        "${DEBLOAT_BIN}" --status
    else
        error "debloat executable not found at ${DEBLOAT_BIN}"
    fi
}

# -----------------------------------------------------------------------------
# Main Entry Point
# -----------------------------------------------------------------------------
if [[ $# -eq 0 ]]; then
    do_status
    exit 0
fi

case "$1" in
    -b|--backup)
        do_backup
        ;;
    -a|--apply|-r|--restore)
        do_apply
        ;;
    -s|--status)
        do_status
        ;;
    -h|--help)
        show_help
        ;;
    *)
        error "Unknown option: $1"
        show_help
        exit 1
        ;;
esac
