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
  static const initialchannelListPlatform = MethodChannel('initialchannellist');
  static const disconnectTopicChannelPlatform = MethodChannel(
      'disconnectTopicChannel');

  List<WalletConnectSession> wcSessions = [];

  @override
  void initState() {
    // init();
    initChannelList();
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
            itemBuilder: (BuildContext context, int index) =>
                sessionsListView(wcSessions, index, context),
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
    wcSessions.clear();

    try {
      var value = await channelListPlatform.invokeMethod('channellistData');
      print('channelList : ${value}');
      var jsonList = json.decode(value) as List;

      for (var json in jsonList) {
        wcSessions.add(WalletConnectSession.fromJson(json));
      }

      print('list $wcSessions');
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void initChannelList() async {
    wcSessions.clear();

    try {
      var value = await initialchannelListPlatform.invokeMethod(
          'initialchannellistData');
      print('initialchannellistData : ${value}');
      var jsonList = json.decode(value) as List;

      for (var json in jsonList) {
        wcSessions.add(WalletConnectSession.fromJson(json));
      }

      print('list $wcSessions');
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Widget sessionsListView(List<WalletConnectSession> listItems, int index,
      context) {
    WalletConnectSession item = listItems[index];
    return InkWell(
      onTap: () {
        showDialog(context: context,
            builder: (c) => endSessionDialog(c, listItems[index]));
      },
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Row(children: [
          // Image.network(item.icon, width: 42, height: 42,),
          SizedBox(
            width: 9.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              SizedBox(
                height: 4,
              ),
              Text(item.description,
                  style: const TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Roboto',
                      overflow: TextOverflow.ellipsis,
                      color: Color(0xff87898E))),
              Text(item.chains,
                  style: const TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Roboto',
                      overflow: TextOverflow.ellipsis,
                      color: Color(0xff87898E))),
              Text(item.methods,
                  style: const TextStyle(
                      fontSize: 12.0,
                      fontFamily: 'Roboto',
                      overflow: TextOverflow.clip,
                      color: Color(0xff87898E))),
            ],
          ),
        ]),
      ),
    );
  }

  Widget endSessionDialog(context, WalletConnectSession item) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Color(0xff2B2F39),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("End Session",
                      style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            Text(
              "End Session?",
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyText1,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    // width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff373C47)),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text('Yes',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText1),
                        ),
                        onPressed: () {
                          endSession(item);
                        }),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: SizedBox(
                    // width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme
                              .of(context)
                              .buttonColor),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text('No',
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void endSession(WalletConnectSession item) async {
    Navigator.pop(context);

    try {
      print("EndSessionClick");
      var value = await disconnectTopicChannelPlatform.invokeMethod(
          'disconnectTopic', {'topic': item.topic});
      print('disconnect :$value');
      if (value != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Disconnected successfully")));
        initChannelList();
      }
    } catch (e) {
      print(e);
    }
  }

}
