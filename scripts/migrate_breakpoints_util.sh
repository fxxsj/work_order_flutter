#!/bin/bash
# Migrate BreakpointsUtil → ResponsiveLayout
# Usage: ./migrate_breakpoints_util.sh [file...]
#   Without args: migrates all Dart files in lib/
#   With args: migrates specified files only

set -e

IMPORT_OLD="import 'package:work_order_app/src/core/utils/breakpoints_util.dart';"
IMPORT_NEW="import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';"

REPLACEMENTS=(
  "BreakpointsUtil.isXs(context)"
  "ResponsiveLayout.isXs(context)"
  "BreakpointsUtil.isSm(context)"
  "ResponsiveLayout.isSm(context)"
  "BreakpointsUtil.isMd(context)"
  "ResponsiveLayout.isMd(context)"
  "BreakpointsUtil.isLg(context)"
  "ResponsiveLayout.isLg(context)"
  "BreakpointsUtil.isXl(context)"
  "ResponsiveLayout.isXl(context)"
  "BreakpointsUtil.is2xl(context)"
  "ResponsiveLayout.is2xl(context)"
  "BreakpointsUtil.isMobile(context)"
  "ResponsiveLayout.isMobile(context)"
  "BreakpointsUtil.isTablet(context)"
  "ResponsiveLayout.isTablet(context)"
  "BreakpointsUtil.isDesktop(context)"
  "ResponsiveLayout.isDesktop(context)"
  "BreakpointsUtil.width(context)"
  "ResponsiveLayout.width(context)"
)

migrate_file() {
  local file="$1"
  local changed=0

  # Skip if already migrated
  if grep -q "ResponsiveLayout" "$file" && ! grep -q "BreakpointsUtil" "$file"; then
    echo "  [SKIP] $file (already migrated)"
    return 0
  fi

  # Replace import
  if grep -q "$IMPORT_OLD" "$file"; then
    sed -i "s|$IMPORT_OLD|$IMPORT_NEW|g" "$file"
    changed=1
    echo "  [IMPORT] $file"
  fi

  # Replace method calls
  for i in $(seq 0 2 $((${#REPLACEMENTS[@]} - 2))); do
    local old="${REPLACEMENTS[$i]}"
    local new="${REPLACEMENTS[$((i+1))]}"
    if grep -q "$old" "$file"; then
      sed -i "s|$old|$new|g" "$file"
      changed=1
      echo "  [REPLACE] $file: $old → $new"
    fi
  done

  if [ $changed -eq 0 ]; then
    echo "  [SKIP] $file (no changes needed)"
  fi
}

echo "=== BreakpointsUtil → ResponsiveLayout Migration ==="
echo ""

if [ $# -eq 0 ]; then
  echo "Migrating all Dart files in lib/..."
  find lib/ -name "*.dart" -type f | while read -r file; do
    migrate_file "$file"
  done
else
  echo "Migrating specified files..."
  for file in "$@"; do
    migrate_file "$file"
  done
fi

echo ""
echo "=== Migration complete ==="
echo "Run 'flutter analyze' to check for any issues."
