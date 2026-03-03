import 'package:work_order_app/src/core/network/api_client.dart';

class SupplierApiService {
  SupplierApiService(this._client);

  final ApiClient _client;

  Future<dynamic> fetchSuppliers({
    required int page,
    required int pageSize,
    String? search,
  }) async {
    return _client.get(
      '/suppliers/',
      queryParameters: {
        'page': page,
        'page_size': pageSize,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
  }
}
