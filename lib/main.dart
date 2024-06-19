import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/mainhome.dart';
import 'package:money_manager/user.dart';
import 'package:provider/provider.dart';
import 'package:money_manager/calculator_widget.dart';
import 'FadeAnimation.dart';
import 'tasks.dart';
import 'signup.dart';
import 'package:money_manager/transaction_item.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'auth.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'dart:async';
import 'homePage.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage(),
        '/addmoney': (BuildContext context) => new CalculatorWidget(),
        '/main': (BuildContext context) => new HomePage(),
        '/TransactionItem': (BuildContext context) => new TransactionItem(),
        '/mainHome': (BuildContext context) => new MainHome(),
      },
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _obsecure = true;
  TextEditingController etEmail = new TextEditingController();
  TextEditingController etPassword = new TextEditingController();
  String email = '';
  String password = ' ';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildEmail() {
    return TextFormField();
  }

  Future<bool> SI = Future.value(true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/background2.png'),
                        fit: BoxFit.fill)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 250,
                      child: FadeAnimation(
                          1,
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/light-1.png')),
                            ),
                          )),
                    ),
                    Positioned(
                      left: 130,
                      width: 80,
                      height: 150,
                      child: FadeAnimation(
                          1.3,
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/light-2.png')),
                            ),
                          )),
                    ),
                    Positioned(
                      left: 270,
                      width: 80,
                      height: 150,
                      child: FadeAnimation(
                          1.5,
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/clock.png')),
                            ),
                          )),
                    ),
                    Positioned(
                      child: Container(
                          margin: EdgeInsets.only(top: 30),
                          child: FadeAnimation(
                            1.6,
                            Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontFamily: 'NotoSans',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    FadeAnimation(
                        1.8,
                        Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(129, 251, 115, .2),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10))
                              ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[100]))),
                                child: TextFormField(
                                  controller: etEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter Email Address",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Enter Email Adderss';
                                    } else {
                                      setState(() {
                                        email = etEmail.text;
                                      });
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: etPassword,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.visibility),
                                      onPressed: () {
                                        setState(() {
                                          _obsecure = !_obsecure;
                                        });
                                      },
                                    ),
                                    border: InputBorder.none,
                                    hintText: "Enter Password",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  obscureText: _obsecure,
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Enter Password';
                                    } else {
                                      password = etPassword.text;
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 40,
                    ),
                    FadeAnimation(
                        2,
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(129, 251, 115, 1),
                                Color.fromRGBO(129, 251, 115, .6),
                              ])),
                          child: Center(
                            child: InkWell(
                              onTap: () => {
                                if (_formKey.currentState.validate())
                                  {signin(email, password, context)}
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    FadeAnimation(
                        2,
                        Container(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: new GoogleSignInButton(
                                    darkMode: true,
                                    onPressed: () => googleSignIn()
                                        .whenComplete(
                                            () => authenticate(context))),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeAnimation(
                            1.5,
                            Text(
                              "New to Pocket Manager ?",
                              style: TextStyle(
                                color: Color.fromRGBO(108, 211, 98, 1),
                              ),
                            )),
                        SizedBox(
                          width: 5.0,
                        ),
                        FadeAnimation(
                            1.5,
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignupPage()),
                                );
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    color: Color.fromRGBO(5, 162, 49, 1),
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
