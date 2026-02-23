/// A placeholder class that represents an entity or model.
class Cake {
  const Cake({
    this.uui,
    this.title,
    this.description,
    this.image,
  });

  final String? uui;
  final String? title;
  final String? description;
  final String? image;

  factory Cake.fromJson(Map<String, dynamic> json) {
    return Cake(
      uui: json['uui'],
      title: json['title'],
      description: json['desc'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uui': uui,
      'title': title,
      'desc': description,
      'image': image,
    };
  }
}
