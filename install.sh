#!/usr/bin/env bash
# Dotfiles Installation & Management Script with GNU Stow for-
# macOS
# Fedora Asahi Linux (KDE)

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

# Packages not stowed by default as documented in README.md
EXCLUDED_PACKAGES=(
    "common/notes"
    "macos/brew"
    "macos/misc"
    "macos/scripts"
)

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
  -c, --common-only    Only stow packages in common/
  -o, --os-only        Only stow packages for current OS (macos/ or linux/)
  -p, --package PKG    Only stow a specific package
  -h, --help           Show this"
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
        # Source OS info
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
info "Action:      ${ACTION^^}"
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
    mkdir -p "${TARGET_DIR}/.config/autostart"
    mkdir -p "${TARGET_DIR}/.config/environment.d"
    mkdir -p "${TARGET_DIR}/.config/gtk-3.0"
    mkdir -p "${TARGET_DIR}/.config/gtk-4.0"
    mkdir -p "${TARGET_DIR}/.config/klassy"
    mkdir -p "${TARGET_DIR}/.config/Kvantum"
    mkdir -p "${TARGET_DIR}/.config/kde-material-you-colors"
    mkdir -p "${TARGET_DIR}/.config/xsettingsd"
    mkdir -p "${TARGET_DIR}/.local/bin"
    mkdir -p "${TARGET_DIR}/.local/share/applications"
    mkdir -p "${TARGET_DIR}/.local/share/kwin/scripts"
    mkdir -p "${TARGET_DIR}/.local/share/plasma/plasmoids"
    mkdir -p "${TARGET_DIR}/.local/state"
    if [[ "${OS_NAME}" == "macOS" ]]; then
        mkdir -p "${TARGET_DIR}/Library/Application Support"
    fi
fi

# -----------------------------------------------------------------------------
# Helper: Check If Package Is Excluded
# -----------------------------------------------------------------------------
is_excluded() {
    local cat_name="$1"
    local pkg_name="$2"
    local rel_path="${cat_name}/${pkg_name}"

    for excluded in "${EXCLUDED_PACKAGES[@]}"; do
        if [[ "${rel_path}" == "${excluded}" ]]; then
            return 0
        fi
    done
    return 1
}

# -----------------------------------------------------------------------------
# Clean Stale & Broken Dotfiles Symlinks in Target
# -----------------------------------------------------------------------------
clean_stale_target_links() {
    local category_dir="$1"
    local pkg_name="$2"
    local pkg_path="${category_dir}/${pkg_name}"

    if [[ ! -d "${pkg_path}" ]]; then
        return 0
    fi

    # Find all relative files/dirs in the package
    while IFS= read -r rel_item; do
        [[ -z "${rel_item}" ]] && continue
        local target_item="${TARGET_DIR}/${rel_item}"

        if [[ -L "${target_item}" ]]; then
            local current_link_target
            current_link_target="$(readlink "${target_item}")"
            # If the link points to .dotfiles or is broken, prepare to replace it
            if [[ "${current_link_target}" == *".dotfiles"* ]] || [[ ! -e "${target_item}" ]]; then
                if ${DRY_RUN}; then
                    info "  [dry-run] Would replace stale link: ${target_item} -> ${current_link_target}"
                else
                    rm -f "${target_item}"
                fi
            fi
        elif [[ -f "${target_item}" && "${target_item}" == *".DS_Store"* ]]; then
            if ! ${DRY_RUN}; then
                rm -f "${target_item}"
            fi
        fi
    done < <(cd "${pkg_path}" && find . -mindepth 1 -not -name ".DS_Store" | sed 's|^\./||')
}

# -----------------------------------------------------------------------------
# Stow Helper Function
# -----------------------------------------------------------------------------
stow_package() {
    local category_dir="$1"
    local pkg_name="$2"

    if [[ ! -d "${category_dir}/${pkg_name}" ]]; then
        return 0
    fi

    clean_stale_target_links "${category_dir}" "${pkg_name}"

    local stow_flags=("-v" "-t" "${TARGET_DIR}" "--dir=${category_dir}" "--ignore=\\.DS_Store")

    if ${DRY_RUN}; then
        stow_flags+=("-n")
    fi

    if ${ADOPT}; then
        stow_flags+=("--adopt")
    fi

    case "${ACTION}" in
    restow)
        stow_flags+=("-R" "${pkg_name}")
        ;;
    delete)
        stow_flags+=("-D" "${pkg_name}")
        ;;
    esac

    info "Processing [${category_dir##*/}/${pkg_name}]..."
    if stow "${stow_flags[@]}"; then
        success "Package [${pkg_name}] ${ACTION}ed successfully."
    else
        if ${DRY_RUN}; then
            warn "Package [${pkg_name}] encountered conflicts during simulation."
        else
            error "Failed to ${ACTION} package [${pkg_name}]."
            return 1
        fi
    fi
}

stow_category() {
    local cat_name="$1"
    local cat_path="${SCRIPT_DIR}/${cat_name}"

    if [[ ! -d "${cat_path}" ]]; then
        return 0
    fi

    header "Stowing ${cat_name^^} Configurations"

    for pkg_dir in "${cat_path}"/*; do
        if [[ -d "${pkg_dir}" ]]; then
            local pkg
            pkg="$(basename "${pkg_dir}")"

            # Check if specifically requested
            if [[ -n "${SPECIFIC_PKG}" ]]; then
                if [[ "${pkg}" != "${SPECIFIC_PKG}" ]]; then
                    continue
                fi
            else
                # Skip excluded packages unless specifically requested
                if is_excluded "${cat_name}" "${pkg}"; then
                    continue
                fi
            fi

            stow_package "${cat_path}" "${pkg}"
        fi
    done
}

# -----------------------------------------------------------------------------
# Main Execution
# -----------------------------------------------------------------------------
if [[ "${SCOPE}" == "all" || "${SCOPE}" == "common" ]]; then
    stow_category "common"
fi

if [[ "${SCOPE}" == "all" || "${SCOPE}" == "os" ]]; then
    stow_category "${OS_DIR}"
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
