import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/wallet_connect_session.dart';

class ViewSessions extends StatefulWidget {
  const ViewSessions({Key? key}) : super(key: key);

  @override
  _ViewSessionsState createState() => _ViewSessionsState();
}

class _ViewSessionsState extends State<ViewSessions> {
  static const channelListPlatform = MethodChannel('channellist');

  List<WalletConnectSession> wcSessions = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          wcSessions.isNotEmpty ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: wcSessions.length,
            itemBuilder: (BuildContext context, int index) => sessionsListView(wcSessions, index, context),
          ) : const Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Center(
                child: Text("No recent sessions", style:
                TextStyle(fontFamily: 'Roboto', fontSize: 18.0),)),
          ),
        ],
      ),
    );
  }


  void init() async {
    try {
      var value = await channelListPlatform.invokeMethod('channellistData');
      print('channelList : ${value}');
      var jsonList = json.decode(value) as List;

      for(var json in jsonList) {
        wcSessions.add(WalletConnectSession.fromJson(json));
      }

      print('list $wcSessions');
      setState(() {});

    } catch (e) {
      print(e);
    }
  }

}
