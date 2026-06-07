#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

TARGET="${1:-web}"

case "$TARGET" in
    web)
        flutter build web --release
        ;;
    apk)
        flutter build apk --release
        ;;
    ios)
        flutter build ios --release
        ;;
    *)
        echo "用法: bash scripts/build.sh [web|apk|ios]"
        echo "默认: web"
        exit 1
        ;;
esac
