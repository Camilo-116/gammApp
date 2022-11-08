// import 'random_user_json_response_model.dart';

class UserModel {
  UserModel({
    this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.profilePhoto,
  });

  final int? id;
  String name;
  String username;
  String email;
  String status = "";
  String password = "password";
  List<UserModel> _friends = [];
  String profilePhoto;
  String about =
      'Juegos favoritos: \nRocket League\nFIFA 23\nValorant\nLeague of Legends\nAmong Us';
  String coverPhoto =
      "https://t4.ftcdn.net/jpg/04/09/70/87/360_F_409708782_HxuxOH8f7xSmj5p4ygbAbuJE74vGGj2N.jpg";

  List<UserModel> get friends => _friends;

  set friends(List<UserModel> friends) => _friends = friends;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'profilePhoto': profilePhoto
    };
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
