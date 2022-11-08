// import 'random_user_json_response_model.dart';

class UserDescription {
  UserDescription({
    required this.id,
    required this.name,
    required this.about,
    this.likes,
    this.comments,
    this.shares,
    this.games,
    this.platforms,
    this.coverPhoto,
    this.profilePhoto,
  });

  final int? id;
  final String name;
  List<String> _friends = [];
  String? profilePhoto;
  String? about = "";
  String? coverPhoto = "";
  int? likes = 0;
  int? comments = 0;
  int? shares = 0;
  List<String>? games = [];
  List<String>? platforms = [];

  List<String> get friends => _friends;

  set friends(List<String> friends) => _friends = friends;

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'profilePhoto': profilePhoto};
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
