import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/homePage.dart';
import 'package:provider/provider.dart';
import 'package:money_manager/transaction.dart';
import 'package:money_manager/transaction_item.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'header.dart';
import 'package:money_manager/mainhome.dart';

class TransactionCard extends StatefulWidget {
  final double height;

  const TransactionCard(this.height);
  @override
  _TransactionCardState createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  int _date = 20;
  String uid;
  String uname;
  @override
  _TransactionCardState() {
    super.initState();
    _getUser();
  }
  Future<void> refresh() {
    setState(() {});
  }

  void _getUser() async {
    await FirebaseAuth.instance.currentUser().then((currentuser) => {
          if (currentuser == null)
            {Navigator.pushReplacementNamed(context, "/main")}
          else
            {
              this.uid = currentuser.uid,
              this.uname = currentuser.displayName,
              print(uid)
            }
        });
  }

  initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final providerTransactions = Provider.of<Transactions>(context);

    return Positioned(
      bottom: 0,
      left: mediaQuery.size.width * .03,
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
        width: mediaQuery.size.width * .94,
        height: mediaQuery.size.height * widget.height,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            )),
        child: Column(
          children: <Widget>[
            Container(
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 12),
                    child: InkWell(
                      onTap: () => setState(() {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => FirstPage(uid, uname)));
                      }),
                      child: Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(5, 162, 49, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () => setState(() => _date--),
                          child: const Icon(Icons.arrow_left),
                        ),
                        Text(
                          '$_date ${DateFormat('MMMM yyyy').format(DateTime.now())}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: ' NotoSans',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () => setState(() => _date++),
                          child: const Icon(Icons.arrow_right),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: Firestore.instance
                      .collection("Transactions")
                      .document(uid)
                      .collection(uname)
                      .getDocuments(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    print('UID in streambuilder');
                    print(uid);
                    print(snapshot.data.documents.length);
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return LiquidPullToRefresh(
                        onRefresh: refresh,
                        child: ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, i) {
                            print(i);
                            DocumentSnapshot data = snapshot.data.documents[i];

                            return TransactionItem(
                              title: data["Transaction_Name"].toString(),
                              value: data["Amount"].toString(),
                              category: data["Category"].toString(),
                            );
                          },
                        ),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.none) {
                      return TransactionItem(title: 'NO Data Found');
                    }
                    return CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: CircularProgressIndicator());
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
