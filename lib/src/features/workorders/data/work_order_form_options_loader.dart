import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/features/artworks/data/artwork_api_service.dart';
import 'package:work_order_app/src/features/artworks/domain/artwork.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/dies/data/die_api_service.dart';
import 'package:work_order_app/src/features/dies/domain/die.dart';
import 'package:work_order_app/src/features/embossing_plates/data/embossing_plate_api_service.dart';
import 'package:work_order_app/src/features/embossing_plates/domain/embossing_plate.dart';
import 'package:work_order_app/src/features/foiling_plates/data/foiling_plate_api_service.dart';
import 'package:work_order_app/src/features/foiling_plates/domain/foiling_plate.dart';
import 'package:work_order_app/src/features/materials/data/material_api_service.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/processes/data/process_api_service.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_api_service.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_sales_order_candidate.dart';

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

class WorkOrderFormOptionsLoader {
  WorkOrderFormOptionsLoader(this._client, {this.excludeWorkOrderId});

  final ApiClient _client;
  final int? excludeWorkOrderId;

  Future<WorkOrderFormOptionsData> load() async {
    final customerApi = CustomerApiService(_client);
    final workOrderApi = WorkOrderApiService(_client);
    final productApi = ProductApiService(_client);
    final materialApi = MaterialApiService(_client);
    final processApi = ProcessApiService(_client);
    final artworkApi = ArtworkApiService(_client);
    final dieApi = DieApiService(_client);
    final foilingApi = FoilingPlateApiService(_client);
    final embossingApi = EmbossingPlateApiService(_client);

    final salesOrderFuture = workOrderApi.fetchSalesOrderCandidates(
      excludeWorkOrderId: excludeWorkOrderId,
    );
    final customerFuture = customerApi.fetchCustomers(page: 1, pageSize: 50);
    final productFuture =
        productApi.fetchProducts(pageSize: 50, isActive: true);
    final productPageFuture = productApi.fetchProductPage(pageSize: 50);
    final materialFuture = materialApi.fetchMaterials(page: 1, pageSize: 50);
    final processFuture = processApi.fetchProcesses(page: 1, pageSize: 50);
    final artworkFuture = artworkApi.fetchArtworks(page: 1, pageSize: 50);
    final dieFuture = dieApi.fetchDies(page: 1, pageSize: 50);
    final foilingFuture = foilingApi.fetchFoilingPlates(page: 1, pageSize: 50);
    final embossingFuture =
        embossingApi.fetchEmbossingPlates(page: 1, pageSize: 50);

    final salesOrderPage = await salesOrderFuture;
    final customerPage = await customerFuture;
    final productOptions = await productFuture;
    final productPage = await productPageFuture;
    final materialPage = await materialFuture;
    final processPage = await processFuture;
    final artworkPage = await artworkFuture;
    final diePage = await dieFuture;
    final foilingPage = await foilingFuture;
    final embossingPage = await embossingFuture;

    return WorkOrderFormOptionsData(
      salesOrders: salesOrderPage,
      customers: customerPage.items.map((item) => item.toEntity()).toList(),
      products: productOptions,
      fullProducts: productPage.items.map((dto) => dto.toEntity()).toList(),
      materials: materialPage.items.map((item) => item.toEntity()).toList(),
      processes: processPage.items.map((item) => item.toEntity()).toList(),
      artworks: artworkPage.items.map((item) => item.toEntity()).toList(),
      dies: diePage.items.map((item) => item.toEntity()).toList(),
      foilingPlates: foilingPage.items.map((item) => item.toEntity()).toList(),
      embossingPlates:
          embossingPage.items.map((item) => item.toEntity()).toList(),
    );
  }
}
