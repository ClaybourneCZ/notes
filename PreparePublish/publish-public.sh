#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage:"
    echo "  $0 <source-project> <target-directory>"
    echo
    echo "Example:"
    echo "  $0 ~/projects/my-app-private ~/projects/my-app-public"
    exit 1
fi

SOURCE_ROOT="$(cd "$1" && pwd)"
TARGET_ROOT="$2"

if [[ ! -d "$TARGET_ROOT" ]]; then
    echo "ERROR: Target directory does not exist:"
    echo "  $TARGET_ROOT"
    exit 1
fi

TARGET_ROOT="$(cd "$TARGET_ROOT" && pwd)"

if [[ "$SOURCE_ROOT" == "$TARGET_ROOT" ]]; then
    echo "ERROR: Source and target cannot be the same directory."
    exit 1
fi

INCLUDE_PATHS=(
    "app/Http/Controllers"
    "app/Http/Requests"
    "app/Models"
    "app/Policies"
    "app/Services"

    "database/factories"
    "database/migrations"
    "database/seeders"

    "resources/js/components"
    "resources/js/composables"
    "resources/js/pages"
    "resources/js/services"
    "resources/js/types"

    "routes"
    "tests"
    "docs"

    ".env.example"
    ".gitignore"
    "composer.json"
    "package.json"
    "vite.config.js"
    "README.md"
    "LICENSE"
)

FORBIDDEN_PATTERNS=(
    ".env"
    ".env.production"
    ".env.local"
    "*.pem"
    "*.key"
    "*.p12"
    "*.pfx"
    "id_rsa"
    "id_ed25519"
)

echo "Source:"
echo "  $SOURCE_ROOT"

echo
echo "Target:"
echo "  $TARGET_ROOT"

echo
echo "Cleaning previous export..."

find "$TARGET_ROOT" \
    -mindepth 1 \
    -maxdepth 1 \
    ! -name ".git" \
    -exec rm -rf {} +

echo
echo "Copying selected files..."

for path in "${INCLUDE_PATHS[@]}"; do
    SOURCE="$SOURCE_ROOT/$path"
    TARGET="$TARGET_ROOT/$path"

    if [[ ! -e "$SOURCE" ]]; then
        echo "SKIP: $path"
        continue
    fi

    echo "COPY: $path"

    mkdir -p "$(dirname "$TARGET")"

    if [[ -d "$SOURCE" ]]; then
        mkdir -p "$TARGET"

        rsync -a \
            --exclude=".DS_Store" \
            --exclude="node_modules" \
            --exclude="vendor" \
            "$SOURCE/" "$TARGET/"
    else
        cp "$SOURCE" "$TARGET"
    fi
done

echo
echo "Running safety checks..."

for pattern in "${FORBIDDEN_PATTERNS[@]}"; do
    MATCHES="$(
        find "$TARGET_ROOT" \
            -path "$TARGET_ROOT/.git" -prune -o \
            -name "$pattern" -print
    )"

    if [[ -n "$MATCHES" ]]; then
        echo
        echo "ERROR: Forbidden file detected:"
        echo "$MATCHES"
        exit 1
    fi
done

echo
echo "Export finished successfully."