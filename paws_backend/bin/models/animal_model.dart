class AnimalModel {
  final String? name, type, breed, color, gender;
  final int? postId, age;
  final bool? microchipped, vaccinated, fixed;

  AnimalModel({
    required this.postId,
    required this.name,
    required this.type,
    required this.breed,
    required this.color,
    required this.gender,
    required this.age,
    required this.microchipped,
    required this.vaccinated,
    required this.fixed,
  });

  factory AnimalModel.fromJson({required Map json}) {
    return AnimalModel(
      postId: json["post_id"],
      name: json["name"],
      type: json["type"],
      breed: json["breed"],
      color: json["color"],
      gender: json["gender"],
      age: json["age"],
      microchipped: json["microchipped"],
      vaccinated: json["vaccinated"],
      fixed: json["fixed"],
    );
  }

  toMap() {
    final jsonMap = {
      "post_id": postId,
      "name": name,
      "type": type,
      "breed": breed,
      "color": color,
      "gender": gender,
      "age": age,
      "microchipped": microchipped,
      "vaccinated": vaccinated,
      "fixed": fixed,
    };

    if (postId == null) {
      return jsonMap;
    }

    return {"post_id": postId, ...jsonMap};
  }
}
