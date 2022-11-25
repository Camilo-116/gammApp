import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gamma/client/ui/controllers/user_controller.dart';
import 'package:gamma/server/services/staticInfoService.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/static_info_controller.dart';

class SelectInterest extends StatefulWidget {
  const SelectInterest({super.key, required this.callback});

  final Function callback;

  @override
  State<SelectInterest> createState() => _SelectInterestState();
}

class _SelectInterestState extends State<SelectInterest> {
  UserController userController = UserController();
  StaticInfoService staticInfoService = StaticInfoService();

  // final List<Widget> _games = <Widget>[
  //   Text(
  //     'GOW:Ragnarok',
  //     style: GoogleFonts.hind(
  //       color: Colors.white,
  //       fontSize: 18,
  //     ),
  //   ),
  //   Text(
  //     'GW 3',
  //     style: GoogleFonts.hind(
  //       color: Colors.white,
  //       fontSize: 18,
  //     ),
  //   ),
  //   Text(
  //     'RL',
  //     style: GoogleFonts.hind(
  //       color: Colors.white,
  //       fontSize: 18,
  //     ),
  //   ),
  //   Text(
  //     'Valorant',
  //     style: GoogleFonts.hind(
  //       color: Colors.white,
  //       fontSize: 18,
  //     ),
  //   ),
  //   Text(
  //     'Fall Guys',
  //     style: GoogleFonts.hind(
  //       color: Colors.white,
  //       fontSize: 18,
  //     ),
  //   )
  // ];
  List<Widget>? _games;
  List<Widget>? _platforms;
  // final List<Widget> _platforms = <Widget>[
  //   Text(
  //     'PS',
  //     style: GoogleFonts.hind(
  //       color: Colors.white,
  //       fontSize: 18,
  //     ),
  //   ),
  //   Text(
  //     'Xbox',
  //     style: GoogleFonts.hind(
  //       color: Colors.white,
  //       fontSize: 18,
  //     ),
  //   ),
  //   Text(
  //     'Switch',
  //     style: GoogleFonts.hind(
  //       color: Colors.white,
  //       fontSize: 18,
  //     ),
  //   ),
  //   Text(
  //     'PC',
  //     style: GoogleFonts.hind(
  //       color: Colors.white,
  //       fontSize: 18,
  //     ),
  //   ),
  //   Text(
  //     'Mobile',
  //     style: GoogleFonts.hind(
  //       color: Colors.white,
  //       fontSize: 18,
  //     ),
  //   )
  // ];
  final List<bool> _selectedPlatforms = <bool>[];
  final List<bool> _selectedGames = <bool>[];
  bool vertical = false;
  bool oneTime = false;

  List<Widget> _platformsWidgets(double width) {
    var platforms = StaticInfo.platforms;
    var tempP = <Widget>[];
    var userPlatforms =
        userController.loggedUserPlatforms.map((p) => p['name']).toList();
    if (platforms.isNotEmpty) {
      for (var platform in platforms) {
        (userPlatforms.contains(platform['name']))
            ? _selectedPlatforms.add(true)
            : _selectedPlatforms.add(false);
        tempP.add(Text(
          platform['name']!,
          style: GoogleFonts.hind(
            color: Colors.white,
            fontSize: (18 / 360) * width,
          ),
        ));
      }
    } else {
      log('No platforms found');
    }
    return tempP;
  }

  List<Widget> _gamesWidgets(double width) {
    var games = StaticInfo.games;
    var tempG = <Widget>[];
    var userGames =
        userController.loggedUserGames.map((g) => g['name']).toList();
    log('userGames: $userGames');
    if (games.isNotEmpty) {
      for (var game in games) {
        (userGames.contains(game['name']))
            ? _selectedGames.add(true)
            : _selectedGames.add(false);
        tempG.add(Text(
          game['name']! as String,
          style: GoogleFonts.hind(
            color: Colors.white,
            fontSize: (18 / 360) * width,
          ),
        ));
      }
    } else {
      log('No games found');
    }
    return tempG;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final ThemeData theme = Theme.of(context);

    if (!oneTime) {
      log('Entra aqui');
      _platforms = _platformsWidgets(width);
      _games = _gamesWidgets(width);
      oneTime = true;
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 6, 61),
      appBar: AppBar(
        title: const Text("Seleccionar intereses"),
        backgroundColor: const Color.fromARGB(255, 54, 9, 91),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              // ToggleButtons with icons only.
              Text(
                'Juegos',
                style: GoogleFonts.hind(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ToggleButtons(
                  onPressed: (int index) {
                    // All buttons are selectable.
                    setState(() {
                      _selectedGames[index] = !_selectedGames[index];
                    });
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: const Color.fromARGB(255, 177, 10, 163),
                  selectedColor: Colors.white,
                  fillColor: const Color.fromARGB(255, 177, 10, 163),
                  color: Colors.white,
                  constraints: const BoxConstraints(
                    minHeight: 40.0,
                    minWidth: 80.0,
                  ),
                  isSelected: _selectedGames,
                  children: _games!,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Plataformas',
                style: GoogleFonts.hind(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ToggleButtons(
                  direction: vertical ? Axis.vertical : Axis.horizontal,
                  onPressed: (int index) {
                    // All buttons are selectable.
                    setState(() {
                      _selectedPlatforms[index] = !_selectedPlatforms[index];
                    });
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: const Color.fromARGB(255, 85, 4, 133),
                  selectedColor: Colors.white,
                  fillColor: const Color.fromARGB(255, 177, 10, 163),
                  color: Colors.white,
                  constraints: const BoxConstraints(
                    minHeight: 40.0,
                    minWidth: 80.0,
                  ),
                  isSelected: _selectedPlatforms,
                  children: _platforms!,
                ),
              ),
              SizedBox(height: (40 / 756) * height),
              ElevatedButton(
                  onPressed: () {
                    widget.callback(_selectedGames, _selectedPlatforms);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 132, 10, 177),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: (20 / 360) * width,
                        vertical: (10 / 756) * height),
                  ),
                  child: Text(
                    'Guardar y cerrar',
                    style: GoogleFonts.hind(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: (18 / 360) * width,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
