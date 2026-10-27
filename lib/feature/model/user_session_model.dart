class UserSessionModel {
  final String? userId;
  final String? token;

  const UserSessionModel({this.userId, this.token});

  UserSessionModel copyWith({
    String? userId,

    String? token,
  }) {
    return UserSessionModel(
      userId: userId ?? this.userId,

      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {"userId": userId, "token": token};
  }

  factory UserSessionModel.fromJson(Map<String, dynamic> json) {
    return UserSessionModel(
      userId: json["id"]?.toString(),

      token: json["token"],
    );
  }

  bool get isLoggedIn => token != null && token!.isNotEmpty;
}
