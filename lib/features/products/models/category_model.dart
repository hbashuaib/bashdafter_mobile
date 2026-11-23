class CategoryModel {
  final int id;

  final String name;
  final String nameEn;
  final String nameAr;
  final String displayName;

  final String description;

  CategoryModel({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.nameAr,
    required this.displayName,
    required this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nameEn: json['name_en'] ?? '',
      nameAr: json['name_ar'] ?? '',
      displayName: json['display_name'] ?? json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
