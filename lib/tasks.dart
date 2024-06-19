  import 'package:flutter/material.dart';
import 'auth.dart';
import 'main.dart';
class tasks extends StatefulWidget {
    @override
    _tasksState createState() => _tasksState();
  }

  class _tasksState extends State<tasks> {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Tasks'),),
       body:  Container(
           child:Center(
               child: new RaisedButton(
                   onPressed:()=> signOutUser().whenComplete(() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomePage()))),
                   child: new Text('U are in')))
       ),
        ),
      );
    }
  }
