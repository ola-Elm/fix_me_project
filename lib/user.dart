class UserClass {
  String username;
  String email;
  String fcmToken;

  UserClass({
    required this.username,
    required this.email,
    required this.fcmToken,
  });

  factory UserClass.fromMap(Map<String, dynamic> map) {
    return UserClass(
      username: map['username'].toString(),
      email: map['email'].toString(),
      fcmToken: map['fcm_token'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'fcm_token': fcmToken,
    };
  }
}
