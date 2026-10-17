import 'package:project1/core/network/api_client.dart';
import 'package:project1/features/home/admin_home/data/models/admin_dashboard_stats.dart';

class AdminDashboardService {
  AdminDashboardService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<AdminDashboardStats> getStats() async {
    final response = await _apiClient.dio.get('/admin/reports');
    return AdminDashboardStats.fromJson(
      Map<String, dynamic>.from(response.data['data'] as Map),
    );
  }
}
