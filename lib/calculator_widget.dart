import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_manager/auth.dart';
import 'package:money_manager/homePage.dart';
import 'package:money_manager/mainhome.dart';
import 'main.dart';

class CalculatorWidget extends StatefulWidget {
  @override
  _CalculatorWidgetState createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  TextEditingController _moneyController = TextEditingController();
  final databaseReference = Firestore.instance;
  int balance = 0;
  String uid;
  String uname;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    FirebaseUser user = await auth.currentUser();
    if (user.providerData[1].providerId == 'google.com') {
      print(user.providerData[1]);
      print("User Name : ${user.displayName}");
      this.uname = user.displayName;
      uid = user.uid;
    } else {
      this.uname = user.uid;
    }
    var document = Firestore.instance.collection("Balance").document(uid).get();
    return await document.then((doc) {
      setState(() {
        balance = doc.data['Current Balance'];
        print(balance);
      });
    });
  }

  updateData(String balance, String lb) async {
    FirebaseUser user = await auth.currentUser();
    if (user.providerData[1].providerId == 'google.com') {
      print(user.providerData[1]);
      print("User Name : ${user.displayName}");
      this.uname = user.displayName;
      uid = user.uid;
    } else {
      this.uname = user.uid;
    }

    await databaseReference.collection("Balance").document(uid).setData({
      'Current Balance': int.parse(balance),
      'Last Balance': int.parse(lb),
      'Date when last change made': DateTime.now()
    });
  }

  showAlertDialog(BuildContext alert) {
    // set up the buttons

    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Oops You Don't have Sufficient Balance!"),
      content: Text(""),
      actions: [continueButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        color: Color.fromRGBO(27, 175, 4, 1),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 60,
            ),
            Container(
              color: Color.fromRGBO(27, 175, 4, 1),
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text("$balance",
                            style:
                                TextStyle(fontSize: 50, color: Colors.white)),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Balance",
                            style: TextStyle(
                              fontSize: 50,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Color.fromRGBO(27, 175, 4, 1),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 40.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.add_circle),
                      color: Colors.blue,
                      iconSize: 50,
                      onPressed: () => {add_money(_moneyController.text)},
                    ),
                    SizedBox(
                      width: 192,
                    ),
                    IconButton(
                        icon: Icon(Icons.remove_circle),
                        color: Colors.red,
                        iconSize: 50,
                        onPressed: () => {remove_money(_moneyController.text)})
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[100]))),
              child: TextFormField(
                controller: _moneyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Money",
                    hintStyle: TextStyle(color: Colors.grey[400])),
                // ignore: missing_return
                validator: (String value) {
                  if (value.isEmpty || int.parse(value) < 0) {
                    return 'Enter atleast Rs.1';
                  }
                },
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 100,
              color: Color.fromRGBO(27, 175, 4, 1),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "Add Amount",
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
              ),
            ),
            Container(
              height: 70,
              color: Color.fromRGBO(27, 175, 4, 1),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    generateAddMoneyBtn(25),
                    generateAddMoneyBtn(50),
                    generateAddMoneyBtn(100),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 70,
            ),
            RaisedButton(
                child: Text('Go back'),
                onPressed: () => {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => MainHome()))
                    }),
            Container(
              height: 110,
              color: Color.fromRGBO(27, 175, 4, 1),
            )
          ],
        ),
      ),
    );
  }

  void add_money(String amount) {
    int last;

    setState(() {
      last = balance;
      balance = balance + int.parse(amount);
      updateData(balance.toString(), last.toString());
    });
  }

  void remove_money(String amount) {
    int last;
    setState(() {
      last = balance;
      if (balance < int.parse(amount)) {
        showAlertDialog(context);
      } else {
        balance = balance - int.parse(amount);

        updateData(balance.toString(), last.toString());
      }
    });
  }

  RaisedButton generateAddMoneyBtn(int amount) {
    return RaisedButton(
        child: Text(
          "\$$amount",
        ),
        color: Colors.white,
        textColor: Colors.deepOrange,
        onPressed: () async {
          setState(() {
            add_money(amount.toString());
          });
        });
  }
}
