#!/usr/bin/env bash
# Dotfiles Installation & Maintainance Script using GNU Stow
#   - macOS
#   - Fedora Asahi Linux (KDE)

set -euo pipefail

# -----------------------------------------------------------------------------
# Configuration & Flags
# -----------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${HOME}"
DRY_RUN=false
VERBOSE=false

for arg in "$@"; do
    case "$arg" in
    -n | --dry-run)
        DRY_RUN=true
        ;;
    -v | --verbose)
        VERBOSE=true
        ;;
    *)
        echo "Unknown option: $arg" >&2
        exit 1
        ;;
    esac
done

# -----------------------------------------------------------------------------
# OS Detection
# -----------------------------------------------------------------------------
case "$(uname -s)" in
Darwin)
    OS_NAME="macOS"
    OS_DIR="macos"
    ;;
Linux)
    OS_NAME="Linux"
    OS_DIR="linux"
    ;;
*)
    echo "✗ Unsupported Operating System: $(uname -s)" >&2
    exit 1
    ;;
esac

echo "==> Dotfiles Sync (GNU Stow)"
echo "    OS:         ${OS_NAME}"
echo "    Repository: ${SCRIPT_DIR}"
echo "    Target:     ${TARGET_DIR}"

if ${DRY_RUN}; then
    echo "    Mode:       DRY-RUN (Simulation)"
fi
echo ""

# Verify GNU Stow is installed
if ! command -v stow &>/dev/null; then
    echo "✗ GNU Stow is not installed!" >&2
    if [[ "${OS_NAME}" == "macOS" ]]; then
        echo "  Install with: brew install stow"
    else
        echo "  Install with: sudo dnf install -y stow"
    fi
    exit 1
fi

# Ensure base target directories exist
if ! ${DRY_RUN}; then
    mkdir -p "${TARGET_DIR}/.config" "${TARGET_DIR}/.local/bin"
    if [[ "${OS_DIR}" == "macos" ]]; then
        mkdir -p "${TARGET_DIR}/Applications"
        mkdir -p "${TARGET_DIR}/Library/Application Support/Code/User"
        mkdir -p "${TARGET_DIR}/Library/Application Support/Mousecape"
    else
        mkdir -p "${TARGET_DIR}/.local/share/applications"
        mkdir -p "${TARGET_DIR}/.local/share/plasma/plasmoids"
        mkdir -p "${TARGET_DIR}/.local/share/kwin/scripts"
    fi
fi

# -----------------------------------------------------------------------------
# Stow Execution
# -----------------------------------------------------------------------------
stow_flags=(
    "-R"
    "-t" "${TARGET_DIR}"
    "--dir=${SCRIPT_DIR}"
    "--ignore=\\.DS_Store"
)

if ${VERBOSE}; then
    stow_flags+=("-v")
fi

if ${DRY_RUN}; then
    stow_flags+=("-n")
fi

echo "==> Syncing common configurations..."
stow "${stow_flags[@]}" common

echo "==> Syncing ${OS_NAME} configurations..."
if [[ "${OS_DIR}" == "macos" ]]; then
    stow "${stow_flags[@]}" --ignore="^(Brewfile|scripts)$" macos
else
    stow "${stow_flags[@]}" linux
fi

echo ""
if ${DRY_RUN}; then
    echo "✓ Dry-run complete. No changes made."
else
    echo "✓ All dotfiles synced successfully!"
    echo "  To reload shell: source ~/.zshrc"
fi
