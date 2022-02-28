import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallet_connect_flutter/view_sessions.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  static const platform = MethodChannel('walletConnectChannel');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Home Page'),
    );
  }

  init() async {
    try {
      var value = await platform.invokeMethod('getBottomSheets');

      showModalBottomSheet(context: context, builder: (c) => Container(child: Text(value.toString()),));
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const platform = MethodChannel('connectionChannel');
  TextEditingController uriController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: () {
              showModalBottomSheet(context: context, builder: (c) => Container(child: Column( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                TextField(controller: uriController,),
                ElevatedButton(onPressed: initConnection, child: Text('ok'))
              ],),));
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
      var value = await platform.invokeMethod('initConnection' , parameters );

      print("valueeee0 $value");
      var json1 = json.decode(value);
      print("valueeee1 ${json1}");
      print("valueeee2 ${json1.toString()}");


      showDialog(context: context, builder: (c) => Dialog(child: Container(child: Text(value.toString()),),));
    } catch (e) {
      print(e);
    }
  }
}
