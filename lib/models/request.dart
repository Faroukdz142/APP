import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trustlaundry/models/my_address.dart';

class Request {
  final String date;
  final String id;
  final String period;
  final Timestamp timeStamp;
  String status;
  final MyAddress address;
  final String userId;
  Request({
    required this.status,
    required this.address,
    required this.timeStamp,
    required this.date,
    required this.id,
    required this.period,
    required this.userId,
  });
  factory Request.fromJson(json) {
    print(json["address"]);
    return Request(
      address: MyAddress.fromJson(json["address"]),
      status: json["status"],
      timeStamp: json["timeStamp"],
      date: json["date"],
      id: json["id"],
      period: json["period"],
      userId: json["userId"],
    );
  }
}
