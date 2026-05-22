#!/usr/bin/env bash
set -euo pipefail

failures=0

report_failure() {
  local title="$1"
  local body="$2"
  if [[ -n "$body" ]]; then
    printf '\n%s\n%s\n' "$title" "$body"
    failures=$((failures + 1))
  fi
}

domain_to_data_allowed='^lib/src/features/(finance_invoices/domain/invoice_repository|inventory_delivery/domain/delivery_order_repository|inventory_quality/domain/quality_inspection_repository|purchase_orders/domain/purchase_order_repository|sales_orders/domain/sales_order_repository|tasks/domain/task_assignment_rule_repository|tasks/domain/task_repository|workorders/domain/work_order_flow_repository|workorders/domain/work_order_repository)\.dart:'

domain_to_data=$(
  rg -n "package:work_order_app/src/features/.*/data/" lib/src/features/*/domain \
    | rg -v "$domain_to_data_allowed" || true
)
report_failure "New domain -> data imports are not allowed:" "$domain_to_data"

application_to_data_allowed='^lib/src/features/(inventory_quality/application/quality_inspection_view_model|notification/application/notification_view_model|tasks/application/task_assignment_rule_view_model)\.dart:'

application_to_data=$(
  rg -n "package:work_order_app/src/features/.*/data/" lib/src/features/*/application \
    | rg -v "$application_to_data_allowed" || true
)
report_failure "New application -> data imports are not allowed:" "$application_to_data"

core_to_app_pages=$(
  rg -n "src/core/(router/app_router|presentation/layout/(content_page|page_registry))\\.dart" lib test || true
)
report_failure "Use app-level router/page registry paths instead of old core paths:" "$core_to_app_pages"

getx_usage=$(
  rg -n "package:get|get/|Get\\.|GetX|Obx\\(" lib test pubspec.yaml || true
)
report_failure "GetX is no longer part of the architecture:" "$getx_usage"

if (( failures > 0 )); then
  exit 1
fi

printf 'Architecture checks passed.\n'
