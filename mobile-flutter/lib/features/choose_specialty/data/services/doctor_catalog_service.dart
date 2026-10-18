import 'package:dio/dio.dart';
import 'package:project1/core/constants/api_constants.dart';
import 'package:project1/core/network/api_client.dart';
import 'package:project1/features/choose_specialty/data/models/doctor_model.dart';
import 'package:project1/features/choose_specialty/data/models/specialty_model.dart';

class DoctorCatalogService {
  DoctorCatalogService({ApiClient? apiClient, Dio? dio})
    : _dio = dio ?? (apiClient ?? ApiClient()).dio;

  final Dio _dio;

  Future<List<SpecialtyModel>> getSpecialties() async {
    final response = await _dio.get('/specialties');
    return _parseList(
      response.data,
    ).map(SpecialtyModel.fromJson).toList(growable: false);
  }

  Future<List<DoctorModel>> findDoctors({
    int? specialtyId,
    String query = '',
  }) async {
    final trimmedQuery = query.trim();
    final response = await _dio.get(
      ApiConstants.doctors,
      queryParameters: {
        if (specialtyId != null) 'specialty_id': specialtyId,
        if (trimmedQuery.isNotEmpty) 'q': trimmedQuery,
      },
    );
    return _parseList(
      response.data,
    ).map(DoctorModel.fromJson).toList(growable: false);
  }

  List<Map<String, dynamic>> _parseList(Object? response) {
    if (response is! Map || response['data'] is! List) {
      throw const FormatException('Unexpected catalog response from server.');
    }
    return (response['data'] as List)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList(growable: false);
  }
}
