class FreeFakePostModel {
  final int? id;
  final String? title;
  final String? content;
  final String? slug;
  final String? picture;
  final int? userId;

  const FreeFakePostModel({
    this.id,
    this.title,
    this.content,
    this.slug,
    this.picture,
    this.userId,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "slug": slug,
        "picture": picture,
        "user": userId,
      };

  factory FreeFakePostModel.fromJson(Map<String, dynamic> json) {
    return FreeFakePostModel(
      id: json["id"],
      title: json["title"],
      content: json["content"],
      slug: json["slug"],
      picture: json["picture"],
      userId: int.tryParse(json["user"].toString().split('/').last),
    );
  }
//
}

class A {}
