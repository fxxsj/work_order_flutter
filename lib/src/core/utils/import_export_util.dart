import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/utils/file_download.dart';

/// 通用导入/导出服务
///
/// 使用方式:
/// ```dart
/// final service = ImportExportService();
/// await service.export('/customers/export/', 'customers.xlsx');
/// final result = await service.import('/customers/import_customers/', file);
/// ```
class ImportExportService {
  ImportExportService(this._client);

  final ApiClient _client;

  /// 导出数据到 Excel
  ///
  /// [endpoint] - 导出接口路径，如 '/customers/export/'
  /// [filename] - 保存的文件名，如 'customers.xlsx'
  Future<void> export(String endpoint, String filename) async {
    try {
      final response = await _client.requestRaw(
        endpoint,
        method: 'get',
        responseType: ResponseType.bytes,
      );
      final bytes = response.data;
      if (bytes is List<int>) {
        await saveBytes(Uint8List.fromList(bytes), filename);
      }
    } on ApiException catch (err) {
      throw Exception(err.message.isNotEmpty ? err.message : '导出失败');
    } catch (err) {
      throw Exception('导出失败: $err');
    }
  }

  /// 从文件导入数据
  ///
  /// [endpoint] - 导入接口路径，如 '/customers/import_customers/'
  /// [file] - 要导入的文件
  /// 返回 [ImportResult]
  Future<ImportResult> import(String endpoint, PlatformFile file) async {
    if (file.bytes == null) {
      return ImportResult(successCount: 0, errorCount: 1, errors: ['无法读取文件']);
    }

    try {
      final extension = file.extension?.toLowerCase();
      String contentType;
      if (extension == 'xlsx') {
        contentType =
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
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

      final formData = FormData.fromMap({'file': multipartFile});
      final response = await _client.requestRaw(
        endpoint,
        method: 'post',
        data: formData,
      );

      final payload = response.data;
      if (payload is Map<String, dynamic>) {
        final dataField = payload['data'];
        if (dataField is Map<String, dynamic>) {
          return ImportResult.fromJson(dataField);
        }
        return ImportResult.fromJson(payload);
      }
      return ImportResult(successCount: 0, errorCount: 1, errors: ['未知响应格式']);
    } on ApiException catch (err) {
      throw Exception(err.message.isNotEmpty ? err.message : '导入失败');
    } catch (err) {
      throw Exception('导入失败: $err');
    }
  }
}

/// 导入结果
class ImportResult {
  const ImportResult({
    required this.successCount,
    required this.errorCount,
    this.createdCount,
    this.updatedCount,
    this.errors,
  });

  final int successCount;
  final int errorCount;
  final int? createdCount;
  final int? updatedCount;
  final List<String>? errors;

  factory ImportResult.fromJson(Map<String, dynamic> json) {
    return ImportResult(
      successCount: json['success_count'] as int? ?? 0,
      errorCount: json['error_count'] as int? ?? 0,
      createdCount: json['created_count'] as int?,
      updatedCount: json['updated_count'] as int?,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }
}

/// 导入/导出辅助类
/// 提供便捷方法用于在列表页面添加导入/导出功能
class ImportExportHelper {
  ImportExportHelper(this._service);

  final ImportExportService _service;

  /// 导出数据
  Future<void> export(
    BuildContext context,
    String endpoint,
    String filename, {
    void Function()? onSuccess,
    void Function(String error)? onError,
  }) async {
    try {
      await _service.export(endpoint, filename);
      if (onSuccess != null) {
        onSuccess();
      }
    } catch (err) {
      if (onError != null) {
        onError(err.toString());
      }
    }
  }

  /// 选择文件并导入
  Future<ImportResult?> pickAndImport(
    BuildContext context,
    String endpoint, {
    List<String> allowedExtensions = const ['xlsx', 'xls'],
    void Function(ImportResult result)? onSuccess,
    void Function(String error)? onError,
  }) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );
    if (result == null || result.files.isEmpty) {
      return null;
    }
    final file = result.files.first;
    if (file.bytes == null) {
      if (onError != null) {
        onError('无法读取文件');
      }
      return null;
    }
    try {
      final importResult = await _service.import(endpoint, file);
      if (onSuccess != null) {
        onSuccess(importResult);
      }
      return importResult;
    } catch (err) {
      if (onError != null) {
        onError(err.toString());
      }
      return null;
    }
  }
}
