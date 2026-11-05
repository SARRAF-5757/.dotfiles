#!/usr/bin/env bash

# Default directory
TARGET_DIR="$HOME/Coding"

# Flags
CHECK_PULL=false
CHECK_COMMIT=false

# Parse args
for arg in "$@"; do
  case "$arg" in
  --pull)
    CHECK_PULL=true
    ;;
  --commit)
    CHECK_COMMIT=true
    ;;
  *)
    # Non-flag argument → override directory
    TARGET_DIR="$arg"
    ;;
  esac
done

# If no flags given, check both
if ! $CHECK_PULL && ! $CHECK_COMMIT; then
  CHECK_PULL=true
  CHECK_COMMIT=true
fi

echo "Checking git repos in: $TARGET_DIR"
echo "----------------------------------------"

# Find all git repos
repos=$(find "$TARGET_DIR" -type d -name ".git" | sed 's|/\.git||')

for repo in $repos; do
  cd "$repo" || continue

  needs_attention=false

  ################################
  #        COMMIT CHECK          #
  ################################
  if $CHECK_COMMIT; then
    status=$(git status --porcelain)
    if [ -n "$status" ]; then
      commit_dirty=true
      needs_attention=true
    else
      commit_dirty=false
    fi
  fi

  ################################
  #         PULL CHECK           #
  ################################
  if $CHECK_PULL; then
    upstream=$(git rev-parse --abbrev-ref @{u} 2>/dev/null)

    if [ -n "$upstream" ]; then
      remote_name=$(echo "$upstream" | cut -d'/' -f1)
      remote_url=$(git remote get-url "$remote_name" 2>/dev/null)

      # Only fetch if remote URL is GitHub
      if echo "$remote_url" | grep -qi "github.com"; then
        git fetch --quiet

        local_rev=$(git rev-parse @)
        remote_rev=$(git rev-parse @{u})
        base_rev=$(git merge-base @ @{u})

        if [ "$local_rev" != "$remote_rev" ] && [ "$base_rev" = "$local_rev" ]; then
          pull_needed=true
          needs_attention=true
        else
          pull_needed=false
        fi
      else
        pull_needed=false
      fi
    else
      pull_needed=false
    fi
  fi

  ################################
  #    PRINT IF ATTENTION        #
  ################################
  if $needs_attention; then
    echo ""
    echo "📁 Repo: $repo"
    echo "   ❌ Needs attention"

    if $CHECK_COMMIT && [ "$commit_dirty" = true ]; then
      echo "     • Local changes to commit"
      echo "     --- Git Status ---"
      echo "$status"
    fi

    if $CHECK_PULL && [ "$pull_needed" = true ]; then
      echo "     • Remote changes available (GitHub pull needed)"
    fi
  fi
done
