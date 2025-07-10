class MyBanner {
  final String ar;
  final String id;
  final String en;
  MyBanner({
    required this.ar,
    required this.en,
    required this.id,
  });

  factory MyBanner.fromJson(json) {
    return MyBanner(ar: json["ar"], en: json["en"], id: json["id"]);
  }
}
