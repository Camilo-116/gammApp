import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'message_state.dart';

class LoadingScreen extends StatefulWidget {
  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends MessageState<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Text('');
  }
}
