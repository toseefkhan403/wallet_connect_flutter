import 'package:flutter/material.dart';

class WalletConnectSession {

  String name;
  String icon;
  String description;
  String chains;
  String methods;
  String topic;
  String url;
  String accounts;

  WalletConnectSession(
      this.name, this.icon, this.description, this.chains, this.methods, this.topic, this.url, this.accounts);

  factory WalletConnectSession.fromJson(Map<String,dynamic> json) => WalletConnectSession(
      json['peermeta_name'],
      json['peermeta_icons'].toString(),
      json['peermeta_description'],
      json['permissons_blockchain'].toString(),
      json['permissons_jsonRpc'].toString(),
      json['topic'],
      json['peermeta_url'],
      json['accounts'].toString(),
  );

  @override
  String toString() {
    return 'WalletConnectSession{name: $name, icon: $icon, description: $description, chains: $chains, methods: $methods, topic: $topic, url: $url, accounts: $accounts}';
  }

}

Widget sessionsListView(
    List<WalletConnectSession> listItems, int index, context) {
  WalletConnectSession item = listItems[index];
  return InkWell(
    onTap: () {
      showDialog(context: context, builder: (c) => endSessionDialog(c));
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
                    fontSize: 14.0,
                    fontFamily: 'Roboto',
                    overflow: TextOverflow.ellipsis,
                    color: Color(0xff87898E))),
          ],
        ),
      ]),
    ),
  );
}

Widget endSessionDialog(context) {
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
                        child: Text('Yes',
                            style: Theme.of(context).textTheme.bodyText1),
                      ),
                      onPressed: endSession),
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
                      child: Text('No',
                          style: Theme.of(context).textTheme.bodyText1),
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

// TODO
void endSession() async {

}