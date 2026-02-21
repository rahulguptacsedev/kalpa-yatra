class TravelService {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final String duration;
  final List<String> highlights;
  final String iconName;

  const TravelService({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.duration,
    required this.highlights,
    required this.iconName,
  });

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'imageUrl': imageUrl,
    'price': price,
    'duration': duration,
    'highlights': highlights,
    'iconName': iconName,
  };

  factory TravelService.fromMap(String id, Map<String, dynamic> map) {
    return TravelService(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      duration: map['duration'] ?? '',
      highlights: List<String>.from(map['highlights'] ?? []),
      iconName: map['iconName'] ?? 'explore',
    );
  }
}
