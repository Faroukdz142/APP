class AppUser {
  // final String username;
  final String email;
   final String phoneNumber;
  final String role;
  double? balance;
  AppUser({
    // required this.username,
     required this.phoneNumber,
     required this.email,
    required this.role,
this.balance
  });

  // fromJson method to create an AppUser instance from a JSON map
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      // username: json['username'] as String,
       email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      role: json['role'] as String,
      balance: json['balance'] ?? 0.0,
    );
  }

  // toJson method to convert an AppUser instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      //'username': username,
      'role':role,
      'email':email,
      'phoneNumber': phoneNumber,
    };
  }
}
