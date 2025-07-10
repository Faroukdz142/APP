class MyProduct {
  final String titleAr;
  final String titleEn;
  final String id;
  final double price;
  String? uid;
  int quantity;
  String? docId;
  final String description;
  List? rate;
  final double priceAfterDiscount;
  final String image;

  MyProduct({
    required this.image,
    required this.id,
    this.uid,
    this.docId,
    required this.price,
    required this.description,
    required this.priceAfterDiscount,
    this.rate,
    this.quantity=1,
    required this.titleAr,
    required this.titleEn,
  });

  factory MyProduct.fromJson(json) {
    return MyProduct(
      description: json["description"]??"",
      priceAfterDiscount: json["priceAfterDiscount"],
      rate: json["rate"] ?? [],
      uid: json["uid"]??"",
      image: json["image"],
      quantity:json["quantity"]??1,
      id: json["id"],
      docId: json["docId"]??"",
      price: json["price"],
      titleAr: json["titleAr"],
      titleEn: json["titleEn"],
    );
  }
Map<String, dynamic> toJson() {
    return {
      "description": description,
      "priceAfterDiscount": priceAfterDiscount,
      "rate": rate,
      "uid": uid,
      "quantity":quantity,
      "docId": docId,
      "image": image,
      "id": id,
      "price": price,
      "titleAr": titleAr,
      "titleEn": titleEn,
    };
  }
  double average() {
    if (rate == null) {
      return 0;
    }
    int sum = 0;
    for (int x in rate!) {
      sum += x;
    }
    return sum / 5;
  }
}
