class SubItem {
  final String id;
  String? laundryTypeAr;
  String? laundryTypeEn;
  String titleAr;
  String titleEn;
  double price; 
  int quantity = 0;
  double priceFast;
  SubItem({
    required this.laundryTypeAr,
    required this.laundryTypeEn,
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.price,
    required this.priceFast,
    required this.quantity,
  });

  factory SubItem.fromMap(Map<String, dynamic> map) {
    return SubItem(
      laundryTypeAr: map["laundryTypeAr"],
      laundryTypeEn: map["laundryTypeEn"],
      id: map['id'],
      priceFast: map["fastPrice"],
      quantity: map["quantity"] ?? 0,
      titleAr: map['titleAr'],
      titleEn: map['titleEn'],
      price: map['price'],

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'laundryTypeAr':laundryTypeAr,
      'laundryTypeEn':laundryTypeEn,
      'id': id,
      'fastPrice':priceFast,
      'titleAr': titleAr,
      'titleEn': titleEn,
      'quantity': quantity,
      'price': price,
    };
  }

  String data() {
    return 'SubItem(id: $id, name: $titleAr, price: $price, quantity: $quantity)';
  }
}

class Item {
  final String id;
  final String image;
  String titleAr;
  final String titleEn;
  List<SubItem> subItems;

  Item({
    required this.id,
    required this.image,
    required this.titleAr,
    required this.titleEn,
    required this.subItems,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      image: map['image'],
      titleAr: map['titleAr'],
      titleEn: map['titleEn'],
      subItems: (map['subItems'] as List<dynamic>)
          .map((subItemMap) =>
              SubItem.fromMap(subItemMap as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': image,
      'titleAr': titleAr,
      "titleEn":titleEn,
      'subItems': subItems.map((subItem) => subItem.toMap()).toList(),
    };
  }
}

class MyCategory {
  final String id;
  final String titleAr;
  final String titleEn;
  final List<Item> items;

  MyCategory({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.items,
  });

  factory MyCategory.fromMap(Map<String, dynamic> map) {
    return MyCategory(
      id: map['id'],
      titleAr: map['titleAr'],
      titleEn: map['titleEn'],
      items: (map['items'] as List<dynamic>)
          .map((itemMap) => Item.fromMap(itemMap as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titleAr': titleAr,
      'titleEn':titleEn,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}
