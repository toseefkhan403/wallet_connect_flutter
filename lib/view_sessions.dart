import 'package:flutter/material.dart';

class ViewSessions extends StatefulWidget {
  const ViewSessions({Key? key}) : super(key: key);

  @override
  _ViewSessionsState createState() => _ViewSessionsState();
}

class _ViewSessionsState extends State<ViewSessions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('no active sessions'))
        ],
      ),
    );
  }
}
