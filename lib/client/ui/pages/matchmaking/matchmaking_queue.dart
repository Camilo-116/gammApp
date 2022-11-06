import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/navigation_controller.dart';

class MatchMakingQueue extends StatefulWidget {
  @override
  State<MatchMakingQueue> createState() => _MatchMakingQueueState();
}

class _MatchMakingQueueState extends State<MatchMakingQueue> {
  NavigationController navigation = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _popSplash();
  }

  _popSplash() async {
    await Future.delayed(const Duration(milliseconds: 2000), () {
      navigation.setSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            // decoration: const BoxDecoration(
            //   gradient: RadialGradient(
            //     radius: 20,
            //     colors: [
            //       Color.fromARGB(57, 44, 61, 70),
            //       Color.fromRGBO(81, 103, 117, 0.171),
            //     ],
            //   ),
            color: const Color.fromARGB(176, 57, 53, 70),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: 0.5,
                      child: Image.asset('assets/images/GammApp.png'),
                    )
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel Matchmaking',
                    style: GoogleFonts.hind(
                      fontSize: 18,
                      color: Colors.blueGrey[50],
                      fontWeight: FontWeight.bold,
                    )),
              )
            ],
          )
        ],
      ),
    );
  }
}
