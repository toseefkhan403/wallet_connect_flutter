import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ViewSessions extends StatefulWidget {
  const ViewSessions({Key? key}) : super(key: key);

  @override
  _ViewSessionsState createState() => _ViewSessionsState();
}

class _ViewSessionsState extends State<ViewSessions> {
  static const channelListPlatform = MethodChannel('channellist');
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


  void init() async {
    try {
      var value = await channelListPlatform.invokeMethod('channellistData');
      print('channelList : $value');
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    init();
    super.initState();

  }
}
