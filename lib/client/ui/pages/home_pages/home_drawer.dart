import 'package:flutter/material.dart';

class HomeDrawer extends StatefulWidget {
  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              width: 1,
                              color: Colors.black,
                              style: BorderStyle.solid))),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Image.asset('assets/images/user.png'),
                    ),
                  )),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 18.0, left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Username',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Where u @? The Uber's on me",
                            style: TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 12),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Valorant, Overwatch, OSU,...",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ))),
            ],
          ),
        ),
      ],
    );
  }
}
