import 'package:work_order_app/src/core/network/api_client.dart';

class SupplierApiService {
  SupplierApiService(this._client);

  final ApiClient _client;

  Future<dynamic> fetchSuppliers({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final trimmed = search?.trim();
    return _client.get(
      '/suppliers/',
      queryParameters: {
        'page': page,
        'page_size': pageSize,
        if (trimmed != null && trimmed.isNotEmpty) 'search': trimmed,
      },
    );
  }
}
