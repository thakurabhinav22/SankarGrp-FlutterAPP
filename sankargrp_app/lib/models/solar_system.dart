class SolarSpec {
  final String key;
  final String value;

  const SolarSpec({required this.key, required this.value});

  factory SolarSpec.fromJson(Map<String, dynamic> json) {
    return SolarSpec(
      key: json['key']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
    );
  }
}

class SolarSystem {
  final String id;
  final String name;
  final String category;
  final int price;
  final String priceFormatted;
  final String subsidyAmount;
  final String estimatedDailyGen;
  final String monthlySavings;
  final String co2SavedPerYear;
  final String warranty;
  final String inverterType;
  final String panelType;
  final String recommendedFor;
  final String description;
  final List<SolarSpec> specs;
  final List<String> features;

  const SolarSystem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.priceFormatted,
    required this.subsidyAmount,
    required this.estimatedDailyGen,
    required this.monthlySavings,
    required this.co2SavedPerYear,
    required this.warranty,
    required this.inverterType,
    required this.panelType,
    required this.recommendedFor,
    required this.description,
    required this.specs,
    required this.features,
  });

  factory SolarSystem.fromJson(Map<String, dynamic> json) {
    return SolarSystem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      priceFormatted: json['priceFormatted']?.toString() ?? '',
      subsidyAmount: json['subsidyAmount']?.toString() ?? '',
      estimatedDailyGen: json['estimatedDailyGen']?.toString() ?? '',
      monthlySavings: json['monthlySavings']?.toString() ?? '',
      co2SavedPerYear: json['co2SavedPerYear']?.toString() ?? '',
      warranty: json['warranty']?.toString() ?? '',
      inverterType: json['inverterType']?.toString() ?? '',
      panelType: json['panelType']?.toString() ?? '',
      recommendedFor: json['recommendedFor']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      specs: (json['specs'] as List<dynamic>?)
              ?.map((s) => SolarSpec.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      features: (json['features'] as List<dynamic>?)
              ?.map((f) => f.toString())
              .toList() ??
          [],
    );
  }
}

class DashboardSummary {
  final double currentOutputKw;
  final double todayYieldKwh;
  final int monthlySavingsRupees;
  final int co2OffsetKg;
  final int systemHealthPercentage;
  final String peakHour;
  final int activePlantsCount;

  const DashboardSummary({
    required this.currentOutputKw,
    required this.todayYieldKwh,
    required this.monthlySavingsRupees,
    required this.co2OffsetKg,
    required this.systemHealthPercentage,
    required this.peakHour,
    required this.activePlantsCount,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      currentOutputKw: (json['currentOutputKw'] as num?)?.toDouble() ?? 4.5,
      todayYieldKwh: (json['todayYieldKwh'] as num?)?.toDouble() ?? 20.0,
      monthlySavingsRupees:
          (json['monthlySavingsRupees'] as num?)?.toInt() ?? 2800,
      co2OffsetKg: (json['co2OffsetKg'] as num?)?.toInt() ?? 400,
      systemHealthPercentage:
          (json['systemHealthPercentage'] as num?)?.toInt() ?? 99,
      peakHour: json['peakHour']?.toString() ?? '12:30 PM',
      activePlantsCount: (json['activePlantsCount'] as num?)?.toInt() ?? 1200,
    );
  }
}
