

import 'package:cloud_firestore/cloud_firestore.dart';

class Sub {
  final int pay;
  final int get;


  Sub({
    required this.get,
    required this.pay,
  });

  // Method to create a Sub object from JSON
  factory Sub.fromJson(Map<String, dynamic> json) {
    return Sub(
      get: json['get'],
      pay: json['pay'],
    );
  }

  // Method to convert a Sub object to JSON
  Map<String, dynamic> toJson() {
    return {
      'get': get,
      'pay': pay,
    };
  }
}
class MySub {
  final double pay;
  final double get;

  final Timestamp timeStamp;
  MySub({
    required this.get,
    required this.pay,
    required this.timeStamp,
  });

  // Method to create a Sub object from JSON
  factory MySub.fromJson(Map<String, dynamic> json) {
    return MySub(
      get: json['get'],
      timeStamp: json["timeStamp"],
      pay: json['pay'],
    );
  }

  // Method to convert a Sub object to JSON
  Map<String, dynamic> toJson() {
    return {
      'get': get,
      'timeStamp':Timestamp.now(),
      'pay': pay,
    };
  }
}

