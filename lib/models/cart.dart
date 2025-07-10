import 'package:trustlaundry/models/product.dart';

import 'items.dart';

class Cart{
  final double priceToPay;
  final double totalFastPriceToPay;
  final List<SubItem> itemsToPayFor;
  Cart({
    required this.totalFastPriceToPay,
    required this.priceToPay,
    required this.itemsToPayFor
  });
}

class ProdCart{
  final double priceToPay;
  final List<MyProduct> itemsToPayFor;
  ProdCart({
    required this.priceToPay,
    required this.itemsToPayFor
  });
}