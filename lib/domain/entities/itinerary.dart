class ItineraryStep {
  final String time;
  final String title;
  final String description;
  final String iconName;

  const ItineraryStep({
    required this.time,
    required this.title,
    required this.description,
    required this.iconName,
  });

  Map<String, dynamic> toMap() => {
    'time': time,
    'title': title,
    'description': description,
    'iconName': iconName,
  };

  factory ItineraryStep.fromMap(Map<String, dynamic> map) {
    return ItineraryStep(
      time: map['time'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      iconName: map['iconName'] ?? 'place',
    );
  }
}

class Itinerary {
  final String id;
  final String title;
  final String subtitle;
  final String duration;
  final double price;
  final List<ItineraryStep> steps;

  const Itinerary({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.price,
    required this.steps,
  });

  Map<String, dynamic> toMap() => {
    'title': title,
    'subtitle': subtitle,
    'duration': duration,
    'price': price,
    'steps': steps.map((s) => s.toMap()).toList(),
  };

  factory Itinerary.fromMap(String id, Map<String, dynamic> map) {
    return Itinerary(
      id: id,
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      duration: map['duration'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      steps: (map['steps'] as List<dynamic>? ?? [])
          .map((s) => ItineraryStep.fromMap(s as Map<String, dynamic>))
          .toList(),
    );
  }

  Itinerary copyWith({
    String? title,
    String? subtitle,
    String? duration,
    double? price,
    List<ItineraryStep>? steps,
  }) {
    return Itinerary(
      id: id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      steps: steps ?? this.steps,
    );
  }
}
