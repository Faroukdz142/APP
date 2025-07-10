import 'app_user.dart';

class Report {
  final String message;
  final AppUser appUser;
  Report({
    required this.message,
    required this.appUser,
  });

  factory Report.fromJson(map) {
    return Report(
      message: map["message"],
      appUser: AppUser.fromJson(map["appUser"]),
    );
  }
}
