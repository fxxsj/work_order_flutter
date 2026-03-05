import 'package:work_order_app/src/features/sales_orders/domain/sales_order_detail.dart';

class SalesOrderDetailDto {
  const SalesOrderDetailDto({required this.entity});

  final SalesOrderDetail entity;

  factory SalesOrderDetailDto.fromJson(Map<String, dynamic> json) {
    return SalesOrderDetailDto(entity: SalesOrderDetail.fromJson(json));
  }

  SalesOrderDetail toEntity() => entity;
}
