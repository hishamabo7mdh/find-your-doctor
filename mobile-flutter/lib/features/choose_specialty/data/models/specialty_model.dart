class SpecialtyModel {
  const SpecialtyModel({required this.id, required this.name, this.imagePath});

  final int id;
  final String name;
  final String? imagePath;

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final imagePath = json['image_path'];
    if (id is! num ||
        name is! String ||
        (imagePath != null && imagePath is! String)) {
      throw const FormatException('Invalid specialty response.');
    }
    return SpecialtyModel(
      id: id.toInt(),
      name: name,
      imagePath: imagePath as String?,
    );
  }
}
