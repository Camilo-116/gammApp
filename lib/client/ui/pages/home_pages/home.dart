import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gamma/client/ui/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../server/data/models/post_model.dart';
import '../../../../server/data/models/user_model.dart';
import '../views/user.dart';
import 'discover.dart';
import 'home_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  UserController user_controller = Get.find();

  @override
  Widget build(BuildContext context) {
    List<PostModel> posts = [
      PostModel(
          id: 0,
          user: user_controller.users[0],
          picture: 'https://picsum.photos/seed/901/600',
          caption: "I'm a Dahmer fan",
          likes: 100000,
          comments: 4700,
          shares: 1500),
      PostModel(
          id: 1,
          user: user_controller.users[2],
          picture:
              'https://i.picsum.photos/id/413/400/400.jpg?hmac=-4Fi-wezu1Vi5MiN26ZcAqlCXNbyBGezeISVWgPAhQc',
          caption: "OSU lover 'til the end of my days",
          likes: 2,
          comments: 0,
          shares: 1),
      PostModel(
          id: 2,
          user: user_controller.users[1],
          picture:
              'https://i.picsum.photos/id/270/400/400.jpg?hmac=7wcLGHIwFHGv56-7wUIKXv99dcj4KfcYIsewlE1SmfA',
          caption: "Treino",
          likes: 40000,
          comments: 420,
          shares: 0),
      PostModel(
          id: 3,
          user: user_controller.users[3],
          picture:
              'https://i.picsum.photos/id/166/400/400.jpg?hmac=cHBjLdAgtcrf9aydJi-KSu0n2BfKLNe2LcJ0WpJoso0',
          caption: "Panamá es mío",
          likes: 305948,
          comments: 6969,
          shares: 3)
    ];
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: Container(
          color: Colors.grey,
          child: HomeDrawer(),
        ),
      ),
      drawerDragStartBehavior: DragStartBehavior.start,
      drawerEdgeDragWidth: 40,
      appBar: AppBar(
        backgroundColor: const Color(0xFFB2B2B2),
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'GammApp',
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.radar,
              ),
              splashRadius: 17,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DiscoverGamers()),
                );
              }),
          IconButton(
            icon: const Icon(
              Icons.notifications,
            ),
            splashRadius: 17,
            onPressed: () {},
          ),
        ],
        centerTitle: true,
        elevation: 2,
      ),
      body: _postListView(posts),
    );
  }

  Widget _postListView(List<PostModel> posts) {
    return ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              _postView(posts[index]),
              (index < posts.length - 1)
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Divider(
                        thickness: 1,
                        indent: 15,
                        endIndent: 15,
                        color: Colors.black,
                      ),
                    )
                  : const SizedBox(
                      height: 15,
                    ),
            ],
          );
        });
  }

  Widget _postView(PostModel post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _postAuthor(post.user),
        _postImage(post.picture),
        _postActions(post.likes, post.comments, post.shares),
        _postCaption(post.caption),
      ],
    );
  }

  Widget _postAuthor(UserModel user) {
    const double _imageSize = 44;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 5, 12, 2),
          child: Row(mainAxisSize: MainAxisSize.max, children: [
            Container(
              width: _imageSize,
              height: _imageSize,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset(user.profilePhoto),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserPage(
                              user: user,
                            )),
                  );
                },
                child: Text(
                  user.username,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const Expanded(
              child: Align(
                alignment: AlignmentDirectional(1, 0),
                child:
                    Icon(Icons.keyboard_control, color: Colors.black, size: 24),
              ),
            )
          ]),
        )
      ],
    );
  }

  Widget _postImage(String picture) {
    return AspectRatio(
      aspectRatio: 1,
      child: Image.network(
        picture,
        width: 100,
        height: 300,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _postActions(int likes, int comments, int shares) {
    bool _isLiked = false;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? Colors.red : Colors.black,
                  size: 24,
                ),
                onPressed: () {
                  setState(() {
                    _isLiked = !_isLiked;
                  });
                },
              ),
              Text(
                (likes > 1000000)
                    ? '${num.parse((likes / 1000000).toStringAsFixed(1))} M'
                    : (likes > 1000)
                        ? '${num.parse((likes / 1000).toStringAsFixed(1))} k'
                        : '$likes',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 16),
              ),
              IconButton(
                icon: const Icon(
                  Icons.comment_outlined,
                  color: Colors.black,
                  size: 24,
                ),
                onPressed: () {
                  print('Make a comment...');
                },
              ),
              Text(
                (comments > 1000000)
                    ? '${num.parse((comments / 1000000).toStringAsFixed(1))} M'
                    : (comments > 1000)
                        ? '${num.parse((comments / 1000).toStringAsFixed(1))} k'
                        : '$comments',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 16),
              ),
              IconButton(
                icon: const Icon(
                  Icons.ios_share,
                  color: Colors.black,
                  size: 24,
                ),
                onPressed: () {
                  print('Share pressed ...');
                },
              ),
              Text(
                (shares > 1000000)
                    ? '${num.parse((shares / 1000000).toStringAsFixed(1))} M'
                    : (shares > 1000)
                        ? '${num.parse((shares / 1000).toStringAsFixed(1))} k'
                        : '$shares',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 16),
              ),
            ],
          ))
        ],
      ),
    );
  }

  Widget _postCaption(String caption) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 12, 8),
      child: Text(
        caption,
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }
}
