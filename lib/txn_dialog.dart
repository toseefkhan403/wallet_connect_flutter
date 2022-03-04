import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallet_connect_flutter/main.dart';


const rejectTxnplatform = MethodChannel('rejectTxnChannel');
const approveTxnplatform = MethodChannel('approveTxnChannel');

void showTxnDialog(context, data) {
  print('oyoyoyoy called');
  showDialog(context: context, builder: (context) => Dialog(
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
                Text("Transaction Request",
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
          // Image.network(data['icon'], height: 50, width: 50,),
          Text(
            " ${data['chainId']} \n ${data['jsonrequest']} \n ${data['topic']} \n ${data['methods']}",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
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
  ));
}

// TODO
void approve() async {
  Navigator.pop(navigatorKey.currentContext!);

  try {
    var value = await approveTxnplatform.invokeMethod('approve' , {'result' : '987338983394e08af4ec715e765373fe8c13302e'});

  } catch (e) {
    print(e);
  }
}

void reject() async {
  Navigator.pop(navigatorKey.currentContext!);

  try {
    var value = await rejectTxnplatform.invokeMethod('reject');
  } catch (e) {
    print(e);
  }
}