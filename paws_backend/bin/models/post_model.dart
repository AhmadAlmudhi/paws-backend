class PostModel {
  final String? content, status, time, favoritesNumber;
  final int? postId, userId;
  final List? images;

  PostModel({
    required this.userId,
    required this.postId,
    required this.content,
    required this.status,
    required this.time,
    required this.favoritesNumber,
    required this.images,
  });

  factory PostModel.fromJson({required Map json}) {
    return PostModel(
      userId: json["user_id"],
      postId: json["post_id"],
      content: json["content"],
      status: json["status"],
      time: json["time"],
      favoritesNumber: json["favorites_number"],
      images: json["images"],
    );
  }

  toMap() {
    final jsonMap = {
      "user_id": userId,
      "post_id": userId,
      "content": userId,
      "status": userId,
      "time": userId,
      "favorites_number": userId,
      "images": userId,
    };

    if (postId == null) {
      return jsonMap;
    }

    return {"post_id": postId, ...jsonMap};
  }
}
