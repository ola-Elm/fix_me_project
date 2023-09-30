class UserClass {
  String username;
  String email;
  String fcmToken;
  String userId;

  UserClass({
    required this.username,
    required this.email,
    required this.fcmToken,
    required this.userId,
  });

  factory UserClass.fromMap(Map<String, dynamic> map) {
    return UserClass(
      username: map['username'].toString(),
      email: map['email'].toString(),
      fcmToken: map['fcm_token'].toString(),
      userId: map['userId'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'fcm_token': fcmToken,
      'userId': userId,
    };
  }
}
