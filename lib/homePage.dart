import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/header.dart';
import 'package:money_manager/transaction_card.dart';
import 'package:money_manager/new_Transaction.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'auth.dart';
import 'main.dart';

class FirstPage extends StatefulWidget {
  String uid;
  String uname;
  FirstPage(String uid,String uname){

     this.uid=uid;
     this.uname=uname;
   }

  @override
  _FirstPageState createState() => _FirstPageState(uid,uname);
}

class _FirstPageState extends State<FirstPage> {
  double _height = .55;
  double _opacity = .9;
String uid;
String uname;
_FirstPageState(String uid,String uname)  {
  this.uid=uid;
  this.uname=uname;


}
  //FirebaseAuth auth = FirebaseAuth.instance;
 void initState(){

    FirebaseAuth.instance
      .currentUser().then((currentuser) => {
    if (currentuser == null)
      {Navigator.pushReplacementNamed(context, "/main")}
else
      this.uid=currentuser.uid,
      this.uname=currentuser.displayName,
    _refresh()

  });}
  // _FirstPageState(String uid){
  //
  //   this.uid=uid;
  // }
void _refresh(){
  setState(() {

  });
}
  void _addTransaction() {
    setState(() {
      _height = .08;
      _opacity = 1;
    });
  }

  void _done() {
    setState(() {
      _height = .55;
      _opacity = .9;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(27, 175, 4, 1),
        elevation: 0,
        centerTitle: true,
        title:  Text(
          'Welcome, ${uname}',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'NotoSans',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: new Drawer(
          child: IconButton(
        icon: Icon(FontAwesomeIcons.signOutAlt),
            onPressed:()=> signOutUser().whenComplete(() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomePage()))),
      )),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Header(_addTransaction),
              Newtransaction(_opacity, _done ),
            ],
          ),
          TransactionCard(_height),
        ],
      ),
    );
  }
}
