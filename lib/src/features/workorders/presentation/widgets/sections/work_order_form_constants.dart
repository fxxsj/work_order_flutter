import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';

/// Product source options for work order forms.
const workOrderProductSourceOptions = <AppDropdownOption<String>>[
  AppDropdownOption(value: 'sales_order', label: '客户订单'),
  AppDropdownOption(value: 'stock', label: '库存生产'),
  AppDropdownOption(value: 'reprint', label: '补印'),
  AppDropdownOption(value: 'sample', label: '打样'),
];
