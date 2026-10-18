import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project1/features/choose_specialty/data/models/doctor_model.dart';
import 'package:project1/features/choose_specialty/data/models/specialty_model.dart';
import 'package:project1/features/choose_specialty/data/services/doctor_catalog_service.dart';

void main() {
  test('parses specialty returned by the specialties endpoint', () {
    final specialty = SpecialtyModel.fromJson({
      'id': 4,
      'name': 'القلبية',
      'image_path': 'assets/images/cardiology.png',
    });

    expect(specialty.id, 4);
    expect(specialty.name, 'القلبية');
    expect(specialty.imagePath, 'assets/images/cardiology.png');
  });

  test('parses doctor returned by the filtered doctors endpoint', () {
    final doctor = DoctorModel.fromJson({
      'id': 23,
      'name': 'د. أحمد علي',
      'specialty': 'القلبية',
      'specialty_image_path': 'assets/images/cardiology.png',
      'price': '150.00',
    });

    expect(doctor.id, 23);
    expect(doctor.name, 'د. أحمد علي');
    expect(doctor.specialty, 'القلبية');
    expect(doctor.specialtyImagePath, 'assets/images/cardiology.png');
    expect(doctor.price, 150);
  });

  test('rejects incomplete API records with an explicit format error', () {
    expect(
      () => SpecialtyModel.fromJson({'id': 'unknown'}),
      throwsFormatException,
    );
    expect(() => DoctorModel.fromJson({'id': 2}), throwsFormatException);
  });

  test('requests doctors with the selected specialty id', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test'));
    RequestOptions? request;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          request = options;
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'data': [
                  {'id': 23, 'name': 'د. أحمد علي', 'specialty': 'القلبية'},
                ],
              },
            ),
          );
        },
      ),
    );

    final doctors = await DoctorCatalogService(
      dio: dio,
    ).findDoctors(specialtyId: 4, query: ' أحمد ');

    expect(request?.path, '/doctors');
    expect(request?.queryParameters, {'specialty_id': 4, 'q': 'أحمد'});
    expect(doctors.single.id, 23);
    expect(doctors.single.specialty, 'القلبية');
  });
}
