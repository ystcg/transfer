class Tip {
  final String id;
  final String categoryId;
  final String title;
  final String subtitle;
  final String difficulty; // "Easy", "Medium", "Hard"
  final String estimatedTime;
  final String icon;
  final String? image;
  final List<String> whatYouNeed;
  final List<TipStep> steps;
  final String? proTip;

  const Tip({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.subtitle,
    required this.difficulty,
    required this.estimatedTime,
    required this.icon,
    this.image,
    required this.whatYouNeed,
    required this.steps,
    this.proTip,
  });

  factory Tip.fromJson(Map<String, dynamic> json) {
    return Tip(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      difficulty: json['difficulty'] as String,
      estimatedTime: json['estimatedTime'] as String,
      icon: json['icon'] as String,
      image: json['image'] as String?,
      whatYouNeed: List<String>.from(json['whatYouNeed'] ?? []),
      steps: (json['steps'] as List)
          .map((s) => TipStep.fromJson(s as Map<String, dynamic>))
          .toList(),
      proTip: json['proTip'] as String?,
    );
  }
}

class TipStep {
  final int number;
  final String title;
  final String description;

  const TipStep({
    required this.number,
    required this.title,
    required this.description,
  });

  factory TipStep.fromJson(Map<String, dynamic> json) {
    return TipStep(
      number: json['number'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
}
