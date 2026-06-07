#!/usr/bin/env bash
set -euo pipefail

if pgrep -f "flutter run" > /dev/null 2>&1; then
    pkill -f "flutter run"
    echo "Flutter run 已终止"
else
    echo "Flutter run 未运行"
fi
