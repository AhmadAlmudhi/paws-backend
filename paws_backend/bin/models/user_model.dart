class UserModel {
  final String? username,
      name,
      email,
      image,
      bio,
      authId,
      phone,
      whatsapp,
      country,
      city,
      gender;
  final int? age, userId;
  final List? favorites;

  UserModel({
    required this.userId,
    required this.username,
    required this.name,
    required this.email,
    this.image,
    this.bio,
    required this.phone,
    this.age,
    this.whatsapp,
    this.country,
    this.city,
    this.gender,
    this.favorites,
    required this.authId,
  });

  factory UserModel.fromJson({required Map json}) {
    return UserModel(
      userId: json["user_id"],
      username: json["username"],
      name: json["name"],
      email: json["email"],
      image: json["image"],
      bio: json["bio"],
      phone: json["phone"],
      age: json["age"],
      whatsapp: json["whatsapp"],
      country: json["country"],
      city: json["city"],
      gender: json["gender"],
      favorites: json["favorites"],
      authId: json["auth_id"],
    );
  }

  toMap() {
    final jsonMap = {
      "user_id": userId,
      "username": username,
      "name": name,
      "email": email,
      "image": image,
      "bio": bio,
      "phone": phone,
      "age": age,
      "whatsapp": whatsapp,
      "country": country,
      "city": city,
      "gender": gender,
      "favorites": favorites,
      "auth_id": authId,
    };

    if (userId == null) {
      return jsonMap;
    }

    return {"user_id": userId, ...jsonMap};
  }
}
