import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectInterest extends StatefulWidget {
  const SelectInterest({super.key});

  @override
  State<SelectInterest> createState() => _SelectInterestState();
}

class _SelectInterestState extends State<SelectInterest> {
  final List<Widget> _platforms = <Widget>[
    Text('GOW:Ragnarok'),
    Text('GW 3'),
    Text('RL'),
    Text('Valorant'),
    Text('Fall Guys')
  ];
  final List<Widget> _games = <Widget>[
    Text('PS'),
    Text('Xbox'),
    Text('Switch'),
    Text('PC'),
    Text('Mobile')
  ];
  final List<bool> _selectedPlatforms = <bool>[
    false,
    false,
    false,
    false,
    false
  ];
  final List<bool> _selectedGames = <bool>[false, false, true, false, false];
  bool vertical = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 54, 9, 91),
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
                'Plataformas',
                style: GoogleFonts.hind(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              ToggleButtons(
                direction: vertical ? Axis.vertical : Axis.horizontal,
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
                children: _games,
              ),
              Text(
                'Juegos',
                style: GoogleFonts.hind(
                  color: Colors.white,
                  fontSize: 16,
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
                  children: _platforms,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
