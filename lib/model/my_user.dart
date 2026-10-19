class MyUser {
  static const String collectionName = "Users";

  String id;
  String name;
  String email;
  String phone;
  int avatarId;

  MyUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarId = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "avatarId": avatarId,
    };
  }

  MyUser.fromJson(Map<String, dynamic> json)
      : this(
          id: json["id"] as String? ?? "",
          name: json["name"] as String? ?? "",
          email: json["email"] as String? ?? "",
          phone: json["phone"] as String? ?? "",
          avatarId: json["avatarId"] as int? ?? 1,
        );
}
