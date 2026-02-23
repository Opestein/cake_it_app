class Cake {
  const Cake({
    required this.title,
    required this.description,
    required this.image,
  });

  final String title;

  final String description;

  final String image;

  factory Cake.fromJson(Map<String, dynamic> json) {
    return Cake(
      title: json['title'] as String? ?? 'Untitled Cake',
      description: json['desc'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'desc': description,
      'image': image,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cake &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          description == other.description &&
          image == other.image;

  @override
  int get hashCode => Object.hash(title, description, image);

  @override
  String toString() => 'Cake(title: $title)';
}
