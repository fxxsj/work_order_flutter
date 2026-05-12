class RoleLabels {
  const RoleLabels._();

  static const Map<String, String> labels = {
    'sales': '业务员',
    'supervisor': '主管',
    'manager': '经理',
    'operator': '操作员',
    'finance': '财务',
    'inventory': '仓储',
    'quality': '质检',
    'admin': '系统管理员',
  };

  static String label(String code) => labels[code] ?? code;

  static const Set<String> salesPermissions = {
    'workorder.view_salesorder',
    'workorder.add_salesorder',
    'workorder.change_salesorder',
    'workorder.view_customer',
    'workorder.add_customer',
    'workorder.change_customer',
  };

  static const Set<String> productionPermissions = {
    'workorder.view_workorder',
    'workorder.add_workorder',
    'workorder.change_workorder',
    'workorder.view_workordertask',
    'workorder.change_workordertask',
    'workorder.view_workorderprocess',
    'workorder.change_workorderprocess',
  };

  static const Set<String> financePermissions = {
    'workorder.view_invoice',
    'workorder.add_invoice',
    'workorder.change_invoice',
    'workorder.view_payment',
    'workorder.add_payment',
    'workorder.change_payment',
    'workorder.view_paymentplan',
    'workorder.change_paymentplan',
    'workorder.view_statement',
    'workorder.add_statement',
    'workorder.change_statement',
    'workorder.view_productioncost',
    'workorder.change_productioncost',
  };

  static const Set<String> inventoryPermissions = {
    'workorder.view_productstock',
    'workorder.change_productstock',
    'workorder.view_stockin',
    'workorder.add_stockin',
    'workorder.change_stockin',
    'workorder.view_stockout',
    'workorder.add_stockout',
    'workorder.change_stockout',
    'workorder.view_deliveryorder',
    'workorder.add_deliveryorder',
    'workorder.change_deliveryorder',
  };

  static const Set<String> qualityPermissions = {
    'workorder.view_qualityinspection',
    'workorder.add_qualityinspection',
    'workorder.change_qualityinspection',
  };

  static const Set<String> systemPermissions = {
    'workorder.view_department',
    'workorder.change_department',
    'workorder.view_process',
    'workorder.change_process',
    'workorder.view_taskassignmentrule',
    'workorder.change_taskassignmentrule',
    'workorder.view_systemnotificationsettings',
    'workorder.change_systemnotificationsettings',
    'workorder.view_notificationtemplate',
    'workorder.change_notificationtemplate',
    'workorder.view_auditlog',
  };
}