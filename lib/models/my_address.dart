class MyAddress {
  final bool isExact;
  String? area;
  String? piece;
  String? boulevard;
  String? street;
  double? lat;
  double? lng;
  String? building;
  String? city;
  final String id;
  String? apartmentNum;
  final String phoneNum;
  final String addressTitle;

  MyAddress({
    required this.isExact,
    this.area,
    this.lat,
    this.lng,
    this.piece,
    required this.id,
    this.boulevard,
    this.city,
    this.street,
    this.building,
    required this.addressTitle,
    this.apartmentNum,
    required this.phoneNum,
  });

  // Convert a JSON object to an Address instance
  factory MyAddress.fromJson(json) {
    return MyAddress(
      isExact: json["lat"]!=null,
      area: json["area"],
      lat: json["lat"],
      lng: json["lng"],
      piece: json['piece'],
      id: json["id"],
      city: json["city"],
      addressTitle: json["title"],
      boulevard: json['boulevard'],
      street: json['street'],
      building: json['building'],
      apartmentNum: json['appartementNum'],
      phoneNum: json['phoneNum'],
    );
  }

  // Convert an Address instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'area': area,
      'lat':lat,
      'lng':lng,
      'piece': piece,
      'city':city,
      'boulevard': boulevard,
      'id': id,
      'title': addressTitle,
      'street': street,
      'building': building,
      'appartementNum': apartmentNum,
      'phoneNum': phoneNum,
    };
  }

  Map<String, dynamic> toId() {
    return {
      'id': id,
    };
  }
}
