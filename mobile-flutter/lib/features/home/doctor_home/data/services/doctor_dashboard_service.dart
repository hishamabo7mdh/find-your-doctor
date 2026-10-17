import 'package:dio/dio.dart';
import 'package:project1/core/network/api_client.dart';
import 'package:project1/features/home/doctor_home/data/models/doctor_appointment_model.dart';

class DoctorDashboardService {
  DoctorDashboardService({ApiClient? apiClient})
    : _dio = (apiClient ?? ApiClient()).dio;

  final Dio _dio;

  Future<List<DoctorAppointmentModel>> appointmentsFor(DateTime date) async {
    final response = await _dio.get(
      '/doctor/appointments',
      queryParameters: {'date': _dateString(date)},
    );
    final items = response.data['data'] as List<dynamic>;
    return items
        .map(
          (item) => DoctorAppointmentModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<void> cancel(int appointmentId) async {
    await _dio.delete('/appointments/$appointmentId');
  }

  String _dateString(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
