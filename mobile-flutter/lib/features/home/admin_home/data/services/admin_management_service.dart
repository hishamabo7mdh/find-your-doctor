import 'package:dio/dio.dart';
import 'package:project1/core/network/api_client.dart';
import 'package:project1/features/home/admin_home/data/models/admin_records.dart';

class AdminManagementService {
  AdminManagementService({ApiClient? apiClient})
    : _dio = (apiClient ?? ApiClient()).dio;

  final Dio _dio;

  Future<List<AdminDoctor>> doctors() async {
    final response = await _dio.get(
      '/admin/doctors',
      queryParameters: const {'per_page': 100},
    );
    return _items(
      response.data,
    ).map((item) => AdminDoctor.fromJson(item)).toList();
  }

  Future<List<AdminPatient>> patients() async {
    final response = await _dio.get(
      '/admin/users',
      queryParameters: const {'role': 'patient', 'per_page': 100},
    );
    return _items(
      response.data,
    ).map((item) => AdminPatient.fromJson(item)).toList();
  }

  Future<List<AdminAppointment>> appointments({
    DateTime? day,
    String? status,
  }) async {
    final query = <String, dynamic>{'per_page': 100};
    if (day != null) {
      final date = _dateString(day);
      query['from'] = date;
      query['to'] = date;
    }
    if (status != null) query['status'] = status;

    final response = await _dio.get(
      '/admin/appointments',
      queryParameters: query,
    );
    return _items(
      response.data,
    ).map((item) => AdminAppointment.fromJson(item)).toList();
  }

  Future<void> setDoctorActive(int doctorId, bool isActive) async {
    await _dio.patch('/admin/doctors/$doctorId', data: {'is_active': isActive});
  }

  Future<void> setPatientActive(int patientId, bool isActive) async {
    await _dio.patch('/admin/users/$patientId', data: {'is_active': isActive});
  }

  List<Map<String, dynamic>> _items(Object? response) {
    if (response is! Map || response['data'] is! List) {
      throw const FormatException('Unexpected response from the server.');
    }
    return (response['data'] as List)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  String _dateString(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
