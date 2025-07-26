class Fasilitas {
  final String title;
  final String description;
  final String distance;
  final String imagePath;

  Fasilitas({
    required this.title,
    required this.description,
    required this.distance,
    required this.imagePath,
  });

  factory Fasilitas.fromJson(Map<String, dynamic> json) {
    return Fasilitas(
      title: json['title'],
      description: json['description'],
      distance: json['distance'],
      imagePath: json['imagePath'],
    );
  }
} 