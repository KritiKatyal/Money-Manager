import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_manager/main.dart';
import 'package:money_manager/mainhome.dart';
import 'tasks.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'user.dart';

bool success = false;
FirebaseAuth auth = FirebaseAuth.instance;
final gooleSignIn = GoogleSignIn();

User _userFromFirebaseUser(FirebaseUser user) {
  return user != null ? User(uid: user.uid) : null;
}

Stream<User> get user {
  return auth.onAuthStateChanged.map(_userFromFirebaseUser);
}

Future<bool> googleSignIn() async {
  GoogleSignInAccount googleSignInAccount = await gooleSignIn.signIn();
  if (googleSignInAccount != null) {
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    AuthResult result = await auth.signInWithCredential(credential);

    FirebaseUser user = await auth.currentUser();

    print(user.uid);
    if (user != null) {
      final databaseReference = Firestore.instance.collection('Users');
      await databaseReference.document(user.displayName).setData({
        'User_ID': user.uid,
        'Date_Of_account_creation': DateTime.now(),
        'Email': user.email,
        'Phone Number': user.phoneNumber
      });
      return Future.value(true);
    } else
      return null;
  }
}

Future authenticate(BuildContext context) async {
  FirebaseUser user = await auth.currentUser();
  if (user == null) {
    return showDialog(
        context: context,
        builder: (_) => AssetGiffyDialog(
              image: Image.asset('assets/gif/Blinking_warning.gif'),
              title: Text(
                "Failed",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              description: Text(
                "Please try again to login with google account.",
                textAlign: TextAlign.center,
              ),
              entryAnimation: EntryAnimation.RIGHT,
              onlyOkButton: true,
              onOkButtonPressed: () {
                Navigator.of(context).pushNamed('/main');
              },
            ));
  } else {
    print(user);

    showDialog(
        context: context,
        builder: (_) => FlareGiffyDialog(
              flarePath: 'assets/gif/space_demo.flr',
              flareAnimation: 'loading',
              title: Text(
                "Logged In",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              description: Text(
                "Welcome to Pocket Money Manager",
                textAlign: TextAlign.center,
              ),
              entryAnimation: EntryAnimation.RIGHT,
              onOkButtonPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MainHome()));
              },
              onCancelButtonPressed: () {
                signOutUser().whenComplete(() => Navigator.pop(context));
              },
            ));
  }
  ;
}

Future<bool> signUp(
    String name, String email, String password, BuildContext context) async {
  try {
    AuthResult result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    print(user.uid);
    final databaseReference = Firestore.instance.collection('Users');
    await databaseReference.document(name).setData({
      'User_ID': user.uid,
      'Date_Of_account_creation': DateTime.now(),
      'Name': name,
      'Email': email
    });

    print(user);

    return Future.value(true);
  } catch (e) {
    switch (e.code) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        print('serror');
        return Future.value(false);
    }
  }
}

Future signin(String email, String password, BuildContext context) async {
  try {
    AuthResult result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    showDialog(
        context: context,
        builder: (_) => FlareGiffyDialog(
              flarePath: 'assets/gif/space_demo.flr',
              flareAnimation: 'loading',
              title: Text(
                "Logged In",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              description: Text(
                "Welcome to Pocket Money Manager",
                textAlign: TextAlign.center,
              ),
              entryAnimation: EntryAnimation.RIGHT,
              onOkButtonPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MainHome()));
              },
              onCancelButtonPressed: () {
                signOutUser().whenComplete(() => Navigator.pop(context));
              },
            ));
    return _userFromFirebaseUser(user);
  } catch (e) {
    switch (e.code) {
      case 'ERROR_INVALID_EMAIL':
        print('Invalid Email!');

        showDialog(
            context: context,
            builder: (_) => AssetGiffyDialog(
                  onlyOkButton: true,
                  image: Image.asset('assets/gif/wrong.gif'),
                  title: Text(
                    "Invalid Email or Password",
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  description: Text(
                    "Enter the valid email or password.",
                    textAlign: TextAlign.center,
                  ),
                  entryAnimation: EntryAnimation.RIGHT,
                  onOkButtonPressed: () {
                    Navigator.of(context, rootNavigator: true).pop(false);
                  },
                ));
        return null;
    }
  }
}

Future<bool> signOutUser() async {
  FirebaseUser user = await auth.currentUser();
  if (user.providerData[1].providerId == 'google.com') {
    await gooleSignIn.disconnect();
  }

  await auth.signOut();
  return Future.value(true);
}
