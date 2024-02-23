class UserModel {
  String uid;
  String title;
  String description;
  String image;

  UserModel({
    required this.uid,
    required this.title,
    required this.description,
    required this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> useList) {
    return UserModel(
      uid: useList['uid'],
      title: useList['title'],
      description: useList['description'],
      image: useList['image'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'title': title,
      'description': description,
      'image': image,
    };
  }
}
