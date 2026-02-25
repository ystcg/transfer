class TipCategory {
  final String id;
  final String name;
  final String icon;
  final String description;
  final int tipCount;

  const TipCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.tipCount,
  });

  factory TipCategory.fromJson(Map<String, dynamic> json) {
    return TipCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      description: json['description'] as String,
      tipCount: json['tipCount'] as int,
    );
  }
}
