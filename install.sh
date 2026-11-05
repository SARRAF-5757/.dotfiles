#!/usr/bin/env bash
# Dotfiles Installation & Management Script with GNU Stow
# Supports:
#   - macOS
#   - Fedora Asahi Linux (KDE)

set -euo pipefail

# -----------------------------------------------------------------------------
# Color Codes & Helpers
# -----------------------------------------------------------------------------
BOLD='\033[1m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'

info() { echo -e "${CYAN}ℹ${NC} $*"; }
success() { echo -e "${GREEN}✓${NC} $*"; }
warn() { echo -e "${YELLOW}⚠${NC} $*"; }
error() { echo -e "${RED}✗${NC} $*" >&2; }
header() { echo -e "\n${BOLD}${PURPLE}==>${NC} ${BOLD}$*${NC}"; }

# -----------------------------------------------------------------------------
# Script Directory & Target Setup
# -----------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${HOME}"
ACTION="restow" # default: restow (-R)
DRY_RUN=false
ADOPT=false
SCOPE="all" # all, common, os
SPECIFIC_PKG=""

# -----------------------------------------------------------------------------
# Help Message
# -----------------------------------------------------------------------------
show_help() {
    echo -e "${BOLD}Dotfiles Management Script (GNU Stow)${NC}

${BOLD}Usage:${NC}
  ./install.sh [OPTIONS]

${BOLD}Options:${NC}
  -n, --dry-run        See what would happen if you ran it, without actually running it
  -t, --target DIR     Specify custom target directory (default is \$HOME)
  -R, --restow         Restow packages (prune broken links and relink) [on by default]
  -D, --delete         Unstow / remove symlinks
  -a, --adopt          Adopt existing target files into the package repository
  -c, --common-only    Only stow common configurations
  -o, --os-only        Only stow OS-specific configurations (macos/ or linux/)
  -p, --package PKG    Only stow a specific package/app (e.g. ghostty, karabiner, zed)
  -h, --help           Show this help"
}

# -----------------------------------------------------------------------------
# Parse Command Line Arguments
# -----------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
    case "$1" in
    -n | --dry-run)
        DRY_RUN=true
        shift
        ;;
    -t | --target)
        TARGET_DIR="$2"
        shift 2
        ;;
    -R | --restow)
        ACTION="restow"
        shift
        ;;
    -D | --delete)
        ACTION="delete"
        shift
        ;;
    -a | --adopt)
        ADOPT=true
        shift
        ;;
    -c | --common-only)
        SCOPE="common"
        shift
        ;;
    -o | --os-only)
        SCOPE="os"
        shift
        ;;
    -p | --package)
        SPECIFIC_PKG="$2"
        shift 2
        ;;
    -h | --help)
        show_help
        exit 0
        ;;
    *)
        error "Unknown option: $1"
        show_help
        exit 1
        ;;
    esac
done

# -----------------------------------------------------------------------------
# OS Detection
# -----------------------------------------------------------------------------
OS_TYPE="$(uname -s)"
OS_NAME="Unknown"
DISTRO_NAME=""

case "${OS_TYPE}" in
Darwin)
    OS_NAME="macOS"
    OS_DIR="macos"
    ;;
Linux)
    OS_NAME="Linux"
    OS_DIR="linux"
    if [[ -f /etc/os-release ]]; then
        # shellcheck disable=SC1091
        source /etc/os-release
        DISTRO_NAME="${NAME:-Linux}"
        if grep -qi "asahi" /etc/os-release 2>/dev/null || uname -r | grep -qi "asahi"; then
            DISTRO_NAME="${DISTRO_NAME} (Asahi)"
        fi
    fi
    ;;
*)
    error "Unsupported Operating System: ${OS_TYPE}"
    exit 1
    ;;
esac

# -----------------------------------------------------------------------------
# Preflight Checks
# -----------------------------------------------------------------------------
echo -e "${BOLD}${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${BLUE}║${NC}             ${BOLD}Dotfiles Management Bootstrap (Stow)${NC}           ${BOLD}${BLUE}║${NC}"
echo -e "${BOLD}${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
info "Detected OS: ${BOLD}${OS_NAME}${NC}${DISTRO_NAME:+ (${DISTRO_NAME})}"
info "Repository:  ${SCRIPT_DIR}"
info "Target Dir:  ${TARGET_DIR}"
info "Action:      $(echo "${ACTION}" | tr '[:lower:]' '[:upper:]')"
if ${DRY_RUN}; then
    warn "DRY-RUN MODE ENABLED: No files will be modified"
fi

# Verify GNU Stow is installed
if ! command -v stow &>/dev/null; then
    error "GNU Stow is not installed!"
    if [[ "${OS_NAME}" == "macOS" ]]; then
        info "Install on macOS with: ${BOLD}brew install stow${NC}"
    else
        info "Install on Fedora with: ${BOLD}sudo dnf install -y stow${NC}"
    fi
    exit 1
fi

# Ensure base target directories exist to prevent Stow tree folding
if ! ${DRY_RUN}; then
    mkdir -p "${TARGET_DIR}/.config"
    mkdir -p "${TARGET_DIR}/.local/bin"
    if [[ "${OS_NAME}" == "macOS" ]]; then
        mkdir -p "${TARGET_DIR}/Applications"
        mkdir -p "${TARGET_DIR}/Library/Application Support/Code/User"
        mkdir -p "${TARGET_DIR}/Library/Application Support/Mousecape"
    else
        mkdir -p "${TARGET_DIR}/.config/autostart"
        mkdir -p "${TARGET_DIR}/.config/environment.d"
        mkdir -p "${TARGET_DIR}/.config/gtk-3.0"
        mkdir -p "${TARGET_DIR}/.config/gtk-4.0"
        mkdir -p "${TARGET_DIR}/.config/klassy"
        mkdir -p "${TARGET_DIR}/.config/Kvantum"
        mkdir -p "${TARGET_DIR}/.config/kde-material-you-colors"
        mkdir -p "${TARGET_DIR}/.config/xsettingsd"
        mkdir -p "${TARGET_DIR}/.local/share/applications"
        mkdir -p "${TARGET_DIR}/.local/share/kwin/scripts"
        mkdir -p "${TARGET_DIR}/.local/share/plasma/plasmoids"
    fi
fi

# -----------------------------------------------------------------------------
# Clean Stale & Broken Dotfiles Symlinks in Target
# -----------------------------------------------------------------------------
clean_stale_target_links() {
    local cat_name="$1"
    local cat_path="${SCRIPT_DIR}/${cat_name}"

    [[ ! -d "${cat_path}" ]] && return 0

    while IFS= read -r rel_item; do
        [[ -z "${rel_item}" ]] && continue
        local target_item="${TARGET_DIR}/${rel_item}"

        if [[ -L "${target_item}" ]]; then
            local current_link_target
            current_link_target="$(readlink "${target_item}" 2>/dev/null || true)"
            if [[ "${current_link_target}" == *".dotfiles"* ]] || [[ ! -e "${target_item}" ]]; then
                if ${DRY_RUN}; then
                    info "  [dry-run] Would replace stale link: ${target_item} -> ${current_link_target}"
                else
                    rm -f "${target_item}"
                fi
            fi
        fi
    done < <(cd "${cat_path}" && find . -mindepth 1 -not -name ".DS_Store" | sed 's|^\./||')

    # Also clean any broken symlinks in standard targets pointing to .dotfiles
    for search_dir in "${TARGET_DIR}/.local/bin" "${TARGET_DIR}/.config"; do
        [[ ! -d "${search_dir}" ]] && continue
        for link in "${search_dir}"/*; do
            if [[ -L "${link}" && ! -e "${link}" ]]; then
                local link_target
                link_target="$(readlink "${link}" 2>/dev/null || true)"
                if [[ "${link_target}" == *".dotfiles"* ]]; then
                    if ${DRY_RUN}; then
                        info "  [dry-run] Would remove broken dotfiles link: ${link}"
                    else
                        rm -f "${link}"
                    fi
                fi
            fi
        done
    done
}

# -----------------------------------------------------------------------------
# Stow Category Function
# -----------------------------------------------------------------------------
stow_category() {
    local cat_name="$1"
    local ignore_pattern="$2"
    local cat_path="${SCRIPT_DIR}/${cat_name}"

    if [[ ! -d "${cat_path}" ]]; then
        return 0
    fi

    header "Stowing $(echo "${cat_name}" | tr '[:lower:]' '[:upper:]') Configurations"

    local stow_flags=(
        "-v"
        "-t" "${TARGET_DIR}"
        "--dir=${SCRIPT_DIR}"
        "--ignore=\\.DS_Store"
    )

    if [[ -n "${ignore_pattern}" ]]; then
        stow_flags+=("--ignore=${ignore_pattern}")
    fi

    if ${DRY_RUN}; then
        stow_flags+=("-n")
    fi

    if ${ADOPT}; then
        stow_flags+=("--adopt")
    fi

    case "${ACTION}" in
    restow)
        stow_flags+=("-R" "${cat_name}")
        ;;
    delete)
        stow_flags+=("-D" "${cat_name}")
        ;;
    esac

    info "Processing category [${cat_name}]..."
    if stow "${stow_flags[@]}"; then
        success "Category [${cat_name}] ${ACTION}ed successfully."
    else
        if ${DRY_RUN}; then
            warn "Category [${cat_name}] encountered conflicts during simulation."
        else
            error "Failed to ${ACTION} category [${cat_name}]."
            return 1
        fi
    fi
}

# -----------------------------------------------------------------------------
# Main Execution
# -----------------------------------------------------------------------------
if [[ -n "${SPECIFIC_PKG}" ]]; then
    info "Targeting specific configuration: ${SPECIFIC_PKG}"
    # If specific package requested, check common and OS dir
    found=false
    for c in "common" "${OS_DIR}"; do
        if [[ -d "${SCRIPT_DIR}/${c}/.config/${SPECIFIC_PKG}" ]]; then
            info "Stowing ${SPECIFIC_PKG} from ${c}/.config..."
            mkdir -p "${TARGET_DIR}/.config"
            clean_stale_target_links "${c}"
            stow -v -t "${TARGET_DIR}/.config" --dir="${SCRIPT_DIR}/${c}/.config" -R "${SPECIFIC_PKG}"
            found=true
            break
        fi
    done
    if ! ${found}; then
        warn "Could not find specific package '${SPECIFIC_PKG}' in .config/ of common or ${OS_DIR}."
    fi
else
    if [[ "${SCOPE}" == "all" || "${SCOPE}" == "common" ]]; then
        clean_stale_target_links "common"
        stow_category "common" ""
    fi

    if [[ "${SCOPE}" == "all" || "${SCOPE}" == "os" ]]; then
        clean_stale_target_links "${OS_DIR}"
        if [[ "${OS_DIR}" == "macos" ]]; then
            stow_category "macos" "^(Brewfile|scripts)$"
        else
            stow_category "linux" ""
        fi
    fi
fi

# -----------------------------------------------------------------------------
# Completion Summary
# -----------------------------------------------------------------------------
header "Installation Summary"
if ${DRY_RUN}; then
    success "Dry run simulation complete."
else
    success "Dotfiles have been successfully linked!"
    info "To reload your shell environment, run: ${BOLD}source ~/.zshrc${NC}"
fi
