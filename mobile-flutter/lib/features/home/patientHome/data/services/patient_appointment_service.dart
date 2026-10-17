import 'package:dio/dio.dart';
import 'package:project1/core/constants/api_constants.dart';
import 'package:project1/core/network/api_client.dart';
import 'package:project1/features/home/patientHome/data/models/doctor_model.dart';
import 'package:project1/features/home/patientHome/data/models/specialty_model.dart';

class PatientAppointmentService {
  PatientAppointmentService({ApiClient? apiClient})
    : _dio = (apiClient ?? ApiClient()).dio;

  final Dio _dio;

  Future<List<SpecialtyModel>> getSpecialties() async {
    final response = await _dio.get('/specialties');
    final items = response.data['data'] as List<dynamic>;
    return items
        .map(
          (item) =>
              SpecialtyModel.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  Future<List<DoctorModel>> findDoctors({
    String query = '',
    int? specialtyId,
  }) async {
    final response = await _dio.get(
      ApiConstants.doctors,
      queryParameters: {
        if (query.trim().isNotEmpty) 'q': query.trim(),
        if (specialtyId != null) 'specialty_id': specialtyId,
      },
    );
    final items = response.data['data'] as List<dynamic>;
    return items
        .map(
          (item) =>
              DoctorModel.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  Future<DoctorModel> getDoctor(int id) async {
    final response = await _dio.get('${ApiConstants.doctors}/$id');
    return DoctorModel.fromJson(
      Map<String, dynamic>.from(response.data['data'] as Map),
    );
  }

  Future<List<AppointmentSlot>> getSlots(int doctorId) async {
    final now = DateTime.now();
    final response = await _dio.get(
      '${ApiConstants.doctors}/$doctorId/slots',
      queryParameters: {
        'from': _dateString(now),
        'to': _dateString(now.add(const Duration(days: 13))),
      },
    );
    final items = response.data['data'] as List<dynamic>;
    return items
        .map(
          (item) =>
              AppointmentSlot.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  Future<AppointmentModel> book({
    required int doctorId,
    required AppointmentSlot slot,
  }) async {
    final response = await _dio.post(
      ApiConstants.appointments,
      data: {
        'doctor_id': doctorId,
        'starts_at': slot.startsAt.toIso8601String(),
      },
      options: Options(
        headers: {
          'Idempotency-Key':
              '${doctorId}_${slot.startsAt.toUtc().millisecondsSinceEpoch}',
        },
      ),
    );
    return AppointmentModel.fromJson(
      Map<String, dynamic>.from(response.data['data'] as Map),
    );
  }

  Future<List<AppointmentModel>> myAppointments() async {
    final response = await _dio.get('${ApiConstants.appointments}/my');
    final items = response.data['data'] as List<dynamic>;
    return items
        .map(
          (item) =>
              AppointmentModel.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  Future<void> cancel(int appointmentId) async {
    await _dio.delete('${ApiConstants.appointments}/$appointmentId');
  }

  static String _dateString(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
