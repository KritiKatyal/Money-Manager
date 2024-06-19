import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:money_manager/homePage.dart';
import 'package:money_manager/transaction.dart';

class MainHome extends StatefulWidget {
  @override
  // String uid;
  //
  // MainHome(String uid){
  //   this.uid=uid;
  // }
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  String uid;
  String uname;
  // _MainHomeState(String uid){
  //   this.uid=uid;
  // }

  @override
  void _getUser() async {
    await FirebaseAuth.instance
        .currentUser().then((currentuser) => {
      if (currentuser == null)
        {Navigator.pushReplacementNamed(context, "/main")}

      else{

        this.uid=currentuser.uid,
        this.uname=currentuser.displayName,
        print(uid)
      }

    });

  }
  void initState() {
  _getUser();
  _refresh();
    super.initState();
  }
  Future<void> _refresh(){
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider(
      create: (context) => Transactions(),
      child: MaterialApp(
        home: FirstPage(uid,uname),
      ),
    );
  }
}
