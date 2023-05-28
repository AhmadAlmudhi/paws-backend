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
    this.userId,
    required this.username,
    required this.name,
    required this.email,
    required this.phone,
    required this.authId,
    this.image,
    this.bio,
    this.age,
    this.whatsapp,
    this.country,
    this.city,
    this.gender,
    this.favorites,
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

  profileToMap() {
    final jsonMap = {
      "username": username,
      "name": name,
      "email": email,
      "auth_id": authId,
      "image": image ??
          "https://ugyetukhwfmbnopxgjoi.supabase.co/storage/v1/object/public/imageProfile/images/default.png",
      "bio": bio ?? "empty",
      "favorites": favorites ?? [],
    };

    if (userId == null) {
      return jsonMap;
    }

    return {"user_id": userId, ...jsonMap};
  }

  contactToMap() {
    final jsonMap = {
      "email": email,
      "phone": phone,
      "whatsapp": whatsapp ?? phone,
    };

    if (userId == null) {
      return jsonMap;
    }

    return {"user_id": userId, ...jsonMap};
  }

  detailsToMap() {
    final jsonMap = {
      "phone": phone,
      "age": age ?? 0,
      "country": country ?? "empty",
      "city": city ?? "empty",
      "gender": gender ?? "empty",
    };

    if (userId == null) {
      return jsonMap;
    }

    return {"user_id": userId, ...jsonMap};
  }
}
