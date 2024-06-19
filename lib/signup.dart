import 'package:flutter/material.dart';
import 'FadeAnimation.dart';
import 'auth.dart';
import 'main.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignupPage(),
    ));

class SignupPage extends StatefulWidget {
  @override
  _SignupPage createState() => _SignupPage();
}

class _SignupPage extends State<SignupPage> {
  bool _obsecure = true;
  TextEditingController etName = new TextEditingController();
  TextEditingController etEmail = new TextEditingController();
  TextEditingController etPassword = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                                "Sign Up",
                                style: TextStyle(
                                    fontFamily: 'NotoSans',
                                    color: Colors.white,
                                    fontSize: 40,
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
                                  controller: etName,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter Name",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Enter Name';
                                    }
                                  },
                                ),
                              ),
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
                                    }
                                  },
                                ),
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
                                    hintText: "Create Password",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  obscureText: _obsecure,
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Enter Password';
                                    } else if (value.length < 6) {
                                      return 'Password must be more than 6 character';
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
                                  {
                                    signUp(etName.text, etEmail.text,
                                            etPassword.text, context)
                                        .whenComplete(() => showDialog(
                                            context: context,
                                            builder: (_) => AssetGiffyDialog(
                                                  image: Image.asset(
                                                      'assets/gif/welcome.gif'),
                                                  title: Text(
                                                    "SignUp Succesful",
                                                    style: TextStyle(
                                                        fontSize: 22.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  description: Text(
                                                    "Welcome Onboard!",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  entryAnimation:
                                                      EntryAnimation.RIGHT,
                                                  onlyOkButton: true,
                                                  onOkButtonPressed: () {
                                                    Navigator.of(context)
                                                        .pushNamed('/main');
                                                  },
                                                ))),
                                  }
                              },
                              child: Text(
                                "Register",
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
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeAnimation(
                            1.5,
                            Text(
                              "Have an account ?",
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
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Login',
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
