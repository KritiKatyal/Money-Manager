import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {

  final String title;
  final double value;
  final String category;



  const Transaction(
      {
        @required this.title,
        @required this.value,
        @required this.category,

      });
}

class Transactions with ChangeNotifier {
  List<Transaction> _transactions = [

  ];


  List<Transaction> get transactions {
    return _transactions;
  }
}
