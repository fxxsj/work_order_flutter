import 'package:work_order_app/src/features/artworks/domain/artwork.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/dies/domain/die.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_sales_order_candidate.dart';

/// 施工单表单页加载的基础选项数据。
class WorkOrderFormOptionsData {
  const WorkOrderFormOptionsData({
    required this.salesOrders,
    required this.customers,
    required this.products,
    required this.fullProducts,
    required this.materials,
    required this.processes,
    required this.artworks,
    required this.dies,
    required this.foilingPlates,
    required this.embossingPlates,
  });

  final List<WorkOrderSalesOrderCandidate> salesOrders;
  final List<Customer> customers;
  final List<ProductOption> products;
  final List<Product> fullProducts;
  final List<MaterialItem> materials;
  final List<Process> processes;
  final List<Artwork> artworks;
  final List<Die> dies;
  final List<FoilingPlate> foilingPlates;
  final List<EmbossingPlate> embossingPlates;
}
