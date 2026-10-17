class SpecialtyModel {
  const SpecialtyModel({required this.id, required this.name});

  final int id;
  final String name;

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyModel(id: json['id'] as int, name: json['name'] as String);
  }
}
