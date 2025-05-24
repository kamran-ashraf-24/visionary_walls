class Info {
  final String id;
  final String name;
  final String url;
  final int width;
  final int height;

  Info({
    required this.id,
    required this.name,
    required this.url,
    required this.width,
    required this.height,
  });

  Map<String, dynamic> toJson() => {
      'id': id,
      'author': name,
      'download_url': url,
      'width': width,
      'height': height,
    };

 factory  Info.fromJson(Map<String, dynamic> json) => Info(
      id: json['id'],
      name: json['author'],
      url: json['download_url'],
      width: json['width'],
      height: json['height'],
    );
}
