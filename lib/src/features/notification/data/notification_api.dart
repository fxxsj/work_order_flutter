import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/models/api_response.dart';
import 'package:work_order_app/src/features/notification/domain/notification_model.dart';

class NotificationPage {
  const NotificationPage({
    required this.items,
    this.totalCount,
    this.hasMore = false,
  });

  final List<NotificationModel> items;
  final int? totalCount;
  final bool hasMore;
}

class NotificationApi {
  NotificationApi(this._client);

  final ApiClient _client;

  Future<NotificationPage> fetchNotifications({
    int page = 1,
    int pageSize = 20,
  }) async {
    final ApiResponse response = await _client.get(
      '/notifications/',
      queryParameters: {
        'page': page,
        'page_size': pageSize,
      },
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final results = data['results'];
      if (results is List) {
        final items = results
            .whereType<Map>()
            .map((item) => NotificationModel.fromJson(item.cast<String, dynamic>()))
            .toList();
        return NotificationPage(
          items: items,
          totalCount: _toInt(data['count']),
          hasMore: data['next'] != null,
        );
      }
    }
    return const NotificationPage(items: []);
  }

  Future<int> fetchUnreadCount() async {
    final ApiResponse response = await _client.get('/notifications/unread_count/');
    final data = response.data;
    if (data is Map && data['unread_count'] != null) {
      return _toInt(data['unread_count']) ?? 0;
    }
    return 0;
  }

  Future<NotificationModel?> markRead(String id) async {
    final ApiResponse response = await _client.post('/notifications/$id/mark_read/');
    final data = response.data;
    if (data is Map && data['notification'] is Map) {
      return NotificationModel.fromJson((data['notification'] as Map).cast<String, dynamic>());
    }
    return null;
  }

  Future<int> markAllRead() async {
    final ApiResponse response = await _client.post('/notifications/mark_all_read/');
    final data = response.data;
    if (data is Map && data['count'] != null) {
      return _toInt(data['count']) ?? 0;
    }
    return 0;
  }
}

int? _toInt(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  return int.tryParse(value.toString());
}
