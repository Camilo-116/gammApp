import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';

class DiscoverGamers extends StatefulWidget {
  const DiscoverGamers({Key? key}) : super(key: key);

  @override
  _DiscoverGamersState createState() => _DiscoverGamersState();
}

class _DiscoverGamersState extends State<DiscoverGamers> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late SwipeableCardSectionController swipeableStackController;

  @override
  void initState() {
    super.initState();
    swipeableStackController = SwipeableCardSectionController();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color.fromARGB(255, 34, 15, 57),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: const Color.fromARGB(255, 34, 15, 57),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: (400 / 756) * height,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Image.network(
                          'https://picsum.photos/seed/788/600',
                          width: (100 / 360) * width,
                          height: (100 / 756) * height,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                              size: (30 / 360) * width,
                            ),
                            onPressed: () {
                              log('Left swipe ...');
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: (30 / 360) * width,
                            ),
                            onPressed: () {
                              log('Add ...');
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: (30 / 360) * width,
                            ),
                            onPressed: () {
                              log('Right swipe ...');
                            },
                          ),
                        ],
                      ),
                      Align(
                        alignment: const AlignmentDirectional(-0.9, 0),
                        child: Text(
                          'Nombre de Usuario',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.hind(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: (18 / 360) * width),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(-0.8, 0),
                        child: Text(
                          'Juego favorito:  Rocket League\nRango: Supersonic Legend\nPlataforma: PlayStation 5',
                          style: GoogleFonts.hind(
                              fontSize: (14 / 360) * width,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
