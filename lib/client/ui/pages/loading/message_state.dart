import 'package:flutter/material.dart';

class MessageState<T extends StatefulWidget> extends State<T> {
  late String _message;

  /// Setter for the message variable

  set setMessage(String message) => setState(() {
        _message = message;
      });

  /// Getter for the message variable

  String get getMessage => _message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: new InkWell(
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            /// Paint the area where the inner widgets are loaded with the

            /// background to keep consistency with the screen background

            new Container(
              decoration: BoxDecoration(color: Colors.black),
            ),

            /// Render the background image

            new Container(
              child: Image.asset('', fit: BoxFit.cover),
            ),

            /// Render the Title widget, loader and messages below each other

            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                  flex: 3,
                  child: new Container(
                      child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                      ),
                    ],
                  )),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /// Loader Animation Widget

                      CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.green),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                      ),

                      Text(getMessage),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
