import 'package:flutter/material.dart';
import 'package:money_manager/transaction.dart';

class TransactionItem extends StatefulWidget {


   String title;
   String value;
   String category;


   TransactionItem({this.title,this.value,this.category});

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,

        ),
        title: Text(
         widget.title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
       widget.category,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        trailing: Text(
          '\₹${widget.value}',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.red,
            fontFamily: 'NotoSans',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
