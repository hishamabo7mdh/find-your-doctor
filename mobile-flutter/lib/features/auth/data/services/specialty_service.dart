import 'package:project1/core/network/api_client.dart';
import 'package:project1/features/home/patientHome/data/models/specialty_model.dart';

class SpecialtyService {
  SpecialtyService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<SpecialtyModel>> getSpecialties() async {
    final response = await _apiClient.dio.get('/specialties');
    final items = response.data['data'] as List<dynamic>;
    return items
        .map(
          (item) =>
              SpecialtyModel.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }
}
