class DoctorModel {
  const DoctorModel({
    required this.id,
    required this.name,
    this.specialty,
    this.specialtyImagePath,
    this.price,
  });

  final int id;
  final String name;
  final String? specialty;
  final String? specialtyImagePath;
  final num? price;

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    if (id is! num || name is! String) {
      throw const FormatException('Invalid doctor response.');
    }

    final rawPrice = json['price'];
    final price = switch (rawPrice) {
      num value => value,
      String value => num.tryParse(value),
      _ => null,
    };

    return DoctorModel(
      id: id.toInt(),
      name: name,
      specialty: json['specialty'] as String?,
      specialtyImagePath: json['specialty_image_path'] as String?,
      price: price,
    );
  }
}
