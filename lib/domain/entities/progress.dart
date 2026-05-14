class WeightEntry {
  final DateTime date;
  final double weightKg;

  const WeightEntry({required this.date, required this.weightKg});

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'weightKg': weightKg,
  };

  factory WeightEntry.fromJson(Map<String, dynamic> j) => WeightEntry(
    date: DateTime.parse(j['date']),
    weightKg: (j['weightKg'] as num).toDouble(),
  );
}

class BodyMeasurement {
  final DateTime date;
  final double? chestCm;
  final double? waistCm;
  final double? hipsCm;
  final double? armCm;
  final double? thighCm;

  const BodyMeasurement({
    required this.date,
    this.chestCm,
    this.waistCm,
    this.hipsCm,
    this.armCm,
    this.thighCm,
  });
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String iconAsset;
  final bool unlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.iconAsset,
    this.unlocked = false,
    this.unlockedAt,
  });
}
