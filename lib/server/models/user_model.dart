// import 'random_user_json_response_model.dart';

class UserModel {
  UserModel({
    required this.username,
    required this.email,
    this.extendedId,
    this.profilePhoto = "",
    this.id,
    this.name = "",
    this.status = "Offline",
    this.about =
        "Juegos favoritos: \nRocket League\nFIFA 23\nValorant\nLeague of Legends\nAmong Us",
    this.coverPhoto =
        "https://t4.ftcdn.net/jpg/04/09/70/87/360_F_409708782_HxuxOH8f7xSmj5p4ygbAbuJE74vGGj2N.jpg",
    this.friends = const [],
  });

  final String? extendedId;
  final int? id;
  String name;
  String username;
  String email;
  String status;
  List friends;
  String profilePhoto;
  String about;
  String coverPhoto;

  /*
  List<UserModel> get friends => _friends;

  set friends(List<UserModel> friends) => _friends = friends;
  */

  // ToMap function for the class UserModel
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'name': name,
      'profile': profilePhoto,
      'cover': coverPhoto,
      'status': status,
      'about': about,
      'extended': extendedId,
      'friends': friends,
    };
  }

  void setValues(Map values) {
    name = values['name'] ?? "";
    friends = values['friends'] ?? [];
    profilePhoto = values['profilePhoto'] ?? "";
    about = values['about'] ?? "";
    coverPhoto = values['coverPhoto'] ?? "";
  }

  // @override
  // String toString() {
  //   return 'User{id: $id, name: $name, username: $username, email: $email, profilePhoto : $profilePhoto}';
  // }

  // factory UserModel.fromRemote(UserRemoteModel remoteModel) => UserModel(
  //       gender: remoteModel.gender,
  //       name: remoteModel.name.first + " " + remoteModel.name.last,
  //       city: remoteModel.location.city,
  //       email: remoteModel.email,
  //       picture: remoteModel.picture.thumbnail,
  //     );
}
