import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/utils/file_download.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/data/product_dto.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/products/domain/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._apiService);

  final ProductApiService _apiService;

  @override
  Future<ProductPageDto> getProducts({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) {
    return _apiService.fetchProductPage(page: page, pageSize: pageSize, search: search);
  }

  @override
  Future<ProductDto> createProduct(ProductDto dto) {
    return _apiService.createProduct(dto);
  }

  @override
  Future<ProductDto> updateProduct(ProductDto dto) {
    return _apiService.updateProduct(dto);
  }

  @override
  Future<void> deleteProduct(int id) {
    return _apiService.deleteProduct(id);
  }

  @override
  Future<ProductImage> uploadProductImage(
    int productId,
    MultipartFile imageFile, {
    int sortOrder = 0,
    String? description,
  }) {
    return _apiService.uploadImage(
      productId,
      imageFile,
      sortOrder: sortOrder,
      description: description,
    );
  }

  @override
  Future<void> deleteProductImage(int productId, int imageId) {
    return _apiService.deleteImage(productId, imageId);
  }

  /// 导出产品列表 Excel。
  @override
  Future<void> exportProducts() async {
    try {
      final response = await _apiService.exportProducts();
      final bytes = response.data;
      if (bytes is List<int>) {
        await saveBytes(Uint8List.fromList(bytes), 'products.xlsx');
      }
    } on ApiException catch (err) {
      throw Exception(err.message.isNotEmpty ? err.message : '导出产品列表失败');
    } catch (err) {
      throw Exception('导出产品列表失败: $err');
    }
  }

  /// 导入产品 Excel。
  @override
  Future<ImportProductsResult> importProducts(PlatformFile file) async {
    try {
      final extension = file.extension?.toLowerCase();
      String contentType;
      if (extension == 'xlsx') {
        contentType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      } else if (extension == 'xls') {
        contentType = 'application/vnd.ms-excel';
      } else {
        contentType = 'application/octet-stream';
      }
      final multipartFile = MultipartFile.fromBytes(
        file.bytes!,
        filename: file.name,
        contentType: DioMediaType.parse(contentType),
      );
      return await _apiService.importProducts(multipartFile);
    } on ApiException catch (err) {
      throw Exception(err.message.isNotEmpty ? err.message : '导入产品列表失败');
    } catch (err) {
      throw Exception('导入产品列表失败: $err');
    }
  }
}
