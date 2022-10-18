import 'user_model.dart';

class PostModel {
  PostModel(
      {this.id,
      required this.user,
      required this.picture,
      required this.caption,
      required this.likes,
      required this.comments,
      required this.shares});

  final int? id;
  final UserModel user;
  final String picture;
  String caption;
  int likes; // Cambiar a Lista de id's de usuario que hayan dado like
  int comments; // Cambiar a lista de comentarios, con el usuario asociado
  int shares; // Cambiar a lista de id's de usuario que hayan compartido

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user,
      'picture': picture,
      'caption': caption,
      'likes': likes,
      'comments': comments,
      'shares': shares
    };
  }

  @override
  String toString() {
    return 'Dog{id: $id, user: $user, caption: $caption, picture: $picture, likes: $likes, comments : $comments, shares: $shares}';
  }
}
