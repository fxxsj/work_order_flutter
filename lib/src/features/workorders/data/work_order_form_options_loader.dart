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

class WorkOrderFormOptionsData {
  const WorkOrderFormOptionsData({
    required this.customers,
    required this.products,
    required this.materials,
    required this.processes,
    required this.artworks,
    required this.dies,
    required this.foilingPlates,
    required this.embossingPlates,
  });

  final List<Customer> customers;
  final List<ProductOption> products;
  final List<MaterialItem> materials;
  final List<Process> processes;
  final List<Artwork> artworks;
  final List<Die> dies;
  final List<FoilingPlate> foilingPlates;
  final List<EmbossingPlate> embossingPlates;
}

class WorkOrderFormOptionsLoader {
  WorkOrderFormOptionsLoader(this._client);

  final ApiClient _client;

  Future<WorkOrderFormOptionsData> load() async {
    final customerApi = CustomerApiService(_client);
    final productApi = ProductApiService(_client);
    final materialApi = MaterialApiService(_client);
    final processApi = ProcessApiService(_client);
    final artworkApi = ArtworkApiService(_client);
    final dieApi = DieApiService(_client);
    final foilingApi = FoilingPlateApiService(_client);
    final embossingApi = EmbossingPlateApiService(_client);

    final results = await Future.wait([
      customerApi.fetchCustomers(page: 1, pageSize: 200),
      productApi.fetchProducts(pageSize: 200, isActive: true),
      materialApi.fetchMaterials(page: 1, pageSize: 200),
      processApi.fetchProcesses(page: 1, pageSize: 200),
      artworkApi.fetchArtworks(page: 1, pageSize: 200),
      dieApi.fetchDies(page: 1, pageSize: 200),
      foilingApi.fetchFoilingPlates(page: 1, pageSize: 200),
      embossingApi.fetchEmbossingPlates(page: 1, pageSize: 200),
    ]);

    final customerPage = results[0] as dynamic;
    final productOptions = results[1] as List<ProductOption>;
    final materialPage = results[2] as dynamic;
    final processPage = results[3] as dynamic;
    final artworkPage = results[4] as dynamic;
    final diePage = results[5] as dynamic;
    final foilingPage = results[6] as dynamic;
    final embossingPage = results[7] as dynamic;

    return WorkOrderFormOptionsData(
      customers:
          customerPage.items.map<Customer>((item) => item.toEntity()).toList(),
      products: productOptions,
      materials: materialPage.items
          .map<MaterialItem>((item) => item.toEntity())
          .toList(),
      processes:
          processPage.items.map<Process>((item) => item.toEntity()).toList(),
      artworks:
          artworkPage.items.map<Artwork>((item) => item.toEntity()).toList(),
      dies: diePage.items.map<Die>((item) => item.toEntity()).toList(),
      foilingPlates: foilingPage.items
          .map<FoilingPlate>((item) => item.toEntity())
          .toList(),
      embossingPlates: embossingPage.items
          .map<EmbossingPlate>((item) => item.toEntity())
          .toList(),
    );
  }
}
