import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallet_connect_flutter/txn_dialog.dart';
import 'package:wallet_connect_flutter/view_sessions.dart';

void main() {
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      home: const MyHomePage(title: 'Flutter Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const platform = MethodChannel('connectionChannel');
  static const rejectplatform = MethodChannel('rejectChannel');
  static const approveplatform = MethodChannel('approveChannel');
  TextEditingController uriController = TextEditingController();

  static const methodsChannelPlatform = MethodChannel('methodClickChannel');

  @override
  void initState() {
    methodsChannelPlatform.setMethodCallHandler(_handleMethod);
    super.initState();
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch(call.method) {
      case "methodClickChannel":
        print('methods :: ' + call.arguments.toString());
        showTxnDialog(navigatorKey.currentContext, json.decode(call.arguments.toString()));
        return Future.value("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: () {
              showDialog(context: context, builder: (c) => Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextField(controller: uriController,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(onPressed: initConnection, child: Text('ok')),
                  )
                ],),
              ));
            }, child: Text('Enter URI'),),

            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => ViewSessions()));
            }, child: Text('View Sessions'),),

          ],
        ),
      ),
    );
  }

  void initConnection() async {
    Navigator.pop(context);
    try {
      print("uriController.text: ${uriController.text}");
      var parameters = {'uri':uriController.text};
      var value = await platform.invokeMethod('initConnection' , parameters);

      print('value : $value');
      showDialog(context: context, builder: (c) => initConnectionDialog(c,json.decode(value)));

    } catch (e) {
      print(e);
    }
  }

  Widget initConnectionDialog(context, data) {
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
                  Text("Connection Request",
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
            Image.network(data['icon'], height: 50, width: 50,),
            Text(
              " ${data['name']} \n ${data['description']} \n ${data['chains']} \n ${data['methods']}",
              style: Theme.of(context).textTheme.bodyText1,
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
                          child: Text('Reject',
                              style: Theme.of(context).textTheme.bodyText1),
                        ),
                        onPressed: reject),
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
                          primary: Theme.of(context).buttonColor),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text('Approve',
                            style: Theme.of(context).textTheme.bodyText1),
                      ),
                      onPressed: approve,
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

  void approve() async {
    Navigator.pop(context);

    try {
      var value = await approveplatform.invokeMethod('approve' , {'accountId' : '987338983394e08af4ec715e765373fe8c13302e'});
      print('approvevalue : $value');
    } catch (e) {
      print(e);
    }
  }

  void reject() async {
    Navigator.pop(context);

    try {
      var value = await rejectplatform.invokeMethod('reject');
      print("rejectchannelvalue $value");
    } catch (e) {
      print(e);
    }
  }
}
