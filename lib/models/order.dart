import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'my_address.dart';
import '../ui/order/order.dart';

import 'items.dart';

class AddressInfo {
  final String id;
  AddressInfo({
    required this.id,
  });
  factory AddressInfo.fromJson(json) {
    return AddressInfo(
      id: json["id"],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
    };
  }
}

class UserOrder {
  String? id;
  final Timestamp timeStamp;
  final String userId;
  final double price;
  bool didPay;
  final String instructions;
  final List<SubItem> subItems;
 // final String deliveryDateAndTime;
  final String pickUpDateAndTime;
  final MyAddress? address;
  final bool fast;
  final double fastPrice;
  final UserPaymentMethod paymentMethod;
  String? paymentId;
  String status;

  UserOrder({
    required this.timeStamp,
    required this.fastPrice,
    required this.instructions,
    this.paymentId,
    required this.userId,
    this.id,
    required this.fast,
    required this.address,
    //required this.deliveryDateAndTime,
    required this.didPay,
    required this.status,
    required this.paymentMethod,
    required this.pickUpDateAndTime,
    required this.price,
    required this.subItems,
  });

  // Convert UserOrder to a map
  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'didPay': didPay,
      'status': status,
      'fast':fast,
      'fastPrice':fastPrice,
      'timeStamp': timeStamp,
      'instructions': instructions,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'subItems': subItems.map((item) => item.toMap()).toList(),
     // 'deliveryDateAndTime': deliveryDateAndTime,
      'pickUpDateAndTime': pickUpDateAndTime,
      'address': address!.toJson(),
      'paymentMethod':
          paymentMethod.toString().split('.').last, // Convert enum to string
      'paymentId': paymentId,
    };
  }

  factory UserOrder.fromJson(Map<String, dynamic> json) {
    return UserOrder(
      timeStamp: json["timeStamp"],
      instructions: json["instructions"],
      id: json["id"],
      fast: json["fast"],
      userId: json["userId"],
      status: json["status"],
      price: json['price'].toDouble(), // Ensure double conversion
      fastPrice: json['fastPrice'].toDouble(), // Ensure double conversion
      didPay: json['didPay'],
      subItems: (json['subItems'] as List)
          .map((item) => SubItem.fromMap(item))
          .toList(),
    //  deliveryDateAndTime: json['deliveryDateAndTime'],
      pickUpDateAndTime: json['pickUpDateAndTime'],
      address: MyAddress.fromJson(json["address"]),
     // address: MyAddress.fromJson(json["address"]),
      paymentMethod: UserPaymentMethod.values.firstWhere(
          (e) => e.toString() == 'UserPaymentMethod.${json['paymentMethod']}'),
      paymentId: json['paymentId'],
    );
  }
}
