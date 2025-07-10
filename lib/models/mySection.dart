class MySection {
  final String titleAr;
  final String titleEn;
  final String image;
  final String id;
  MySection({
    required this.id,
    required this.image,
    required this.titleAr,
    required this.titleEn,
  });

  factory MySection.fromJson(json) {
    return MySection(
      titleAr: json["titleAr"],
      titleEn: json["titleEn"],
      id: json["id"],
      image: json["image"],
    );
  }
}
