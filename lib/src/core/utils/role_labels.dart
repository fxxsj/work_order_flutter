class RoleLabels {
  const RoleLabels._();

  static const Map<String, String> labels = {
    'sales': '业务员',
    'supervisor': '主管',
    'manager': '经理',
    'operator': '操作员',
    'finance': '财务',
    'procurement': '采购',
    'design': '设计/制版',
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

  static const Set<String> procurementPermissions = {
    'workorder.view_supplier',
    'workorder.add_supplier',
    'workorder.change_supplier',
    'workorder.view_materialsupplier',
    'workorder.add_materialsupplier',
    'workorder.change_materialsupplier',
    'workorder.view_material',
    'workorder.view_purchaseorder',
    'workorder.add_purchaseorder',
    'workorder.change_purchaseorder',
    'workorder.view_purchaseorderitem',
    'workorder.add_purchaseorderitem',
    'workorder.change_purchaseorderitem',
    'workorder.view_purchasereceiverecord',
    'workorder.change_purchasereceiverecord',
    'workorder.view_productstock',
    'workorder.view_stockin',
  };

  static const Set<String> designPermissions = {
    'workorder.view_workorder',
    'workorder.view_workordertask',
    'workorder.change_workordertask',
    'workorder.view_process',
    'workorder.view_department',
    'workorder.view_artwork',
    'workorder.add_artwork',
    'workorder.change_artwork',
    'workorder.view_artworkproduct',
    'workorder.view_die',
    'workorder.add_die',
    'workorder.change_die',
    'workorder.view_dieproduct',
    'workorder.view_foilingplate',
    'workorder.add_foilingplate',
    'workorder.change_foilingplate',
    'workorder.view_foilingplateproduct',
    'workorder.view_embossingplate',
    'workorder.add_embossingplate',
    'workorder.change_embossingplate',
    'workorder.view_embossingplateproduct',
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
