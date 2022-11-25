import 'dart:developer';

/// This class represents the structure of a User object.
class UserModel {
  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.extendedId,
    this.profilePhoto = 'users_media/user.png',
    this.name,
    this.status = "Offline",
    this.about =
        "Juegos favoritos: \nRocket League\nFIFA 23\nValorant\nLeague of Legends\nAmong Us",
    this.friends = const [],
    this.games = const [],
    this.platforms = const [],
    this.likedPosts = const [],
    this.postsIDs = const [],
  });

  /// Id of the related userBasic.
  String id;

  /// Id of the related userExtended.
  String? extendedId;

  /// Username of the user.
  String username;

  /// Name of the user.
  String? name;

  /// Email of the user.
  String email;

  /// Profilephoto of the user.
  String profilePhoto;

  /// Status of the user.
  String status;

  /// List of friends of the user.
  List<Map<String, String>> friends;

  /// List of liked posts of the user.
  List<String> likedPosts;

  /// List of posts ids of the user.
  List<String> postsIDs;

  /// List of games played frequently by the user.
  List<Map<String, String>> games;

  /// List of platforms used frequently by the user.
  List<Map<String, String>> platforms;

  /// About the user.
  String about;

  /// This method is used to convert a [UserModel] object to a [Map] object containing its attributes.
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'name': name,
      'profile': profilePhoto,
      'status': status,
      'about': about,
      'extendedId': extendedId,
      'friends': friends,
      'likedPosts': likedPosts,
      'postsIDs': postsIDs,
      'games': games,
      'platforms': platforms,
    };
  }

  /// Fill the extra information of the user after a userExtended query.
  ///
  /// Receives a [Map] object containing the extra information of the user.
  /// At the end, the non-required attributes of the user will be filled.
  void setValues(Map values) {
    List<Map<String, String>> f = [];
    values['friends'].forEach((friend) {
      f.add({
        'uuid': friend['uuidBasic'],
        'uuidExtended': friend['uuidExtended'],
        'username': friend['username'],
      });
    });

    List<Map<String, String>> p = [];
    values['platforms'].forEach((platform) {
      p.add({
        'name': platform['name'],
        'logo_url': platform['logo_url'],
      });
    });

    List<Map<String, String>> g = [];
    values['games'].forEach((game) {
      g.add({
        'name': game['name'],
        'icon_url': game['icon_url'],
      });
    });

    extendedId = values['id'];
    name = values['name'] ?? "";
    friends = f;
    likedPosts = List<String>.from(
        values['likedPosts'] ?? List<String>.empty(growable: true));
    postsIDs = List<String>.from(
        values['postsIDs'] ?? List<String>.empty(growable: true));
    games = g;
    platforms = p;
    profilePhoto = values['profilePhoto'] ?? "";
    about = values['about'] ?? "";
  }
}
