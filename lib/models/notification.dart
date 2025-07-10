import 'package:cloud_firestore/cloud_firestore.dart';

class MyNotification {
  final String titleAr;
  final String contentAr;
  final String titleEn;
  final String contentEn;
  final String receipientId;
  final Timestamp timeStamp;
  final String id;
  String? orderId;
  MyNotification({
    required this.contentAr,
    required this.id,
    required this.receipientId,
    required this.timeStamp,
    required this.titleAr,
    required this.titleEn,
    required this.contentEn,
    this.orderId,
  });
  factory MyNotification.fromJson(json) {
    return MyNotification(
      orderId: json["orderId"],
      contentAr: json["contentAr"],
      id: json["id"],
      receipientId: json["receipientId"],
      timeStamp: json['timeStamp'],
      titleAr: json['titleAr'],
      contentEn: json['contentEn'],
      titleEn: json['titleEn'],
    );
  }
}
