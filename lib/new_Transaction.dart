import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/homePage.dart';
import 'package:money_manager/mainhome.dart';
import 'package:money_manager/mainhome.dart';

import 'auth.dart';

class Category {
  int id;
  String name;

  Category(this.id, this.name);

  static List<Category> getCategory() {
    return <Category>[
      Category(1, 'Category'),
      Category(2, 'Entertainment'),
      Category(3, 'Food'),
      Category(4, 'Stationery'),
      Category(5, 'Hostel'),
      Category(6, 'Other'),
    ];
  }
}

List<Category> _companies = Category.getCategory();
List<DropdownMenuItem<Category>> _dropdownMenuItems;
Category _selectedCategory;

class Newtransaction extends StatefulWidget {
  final double opacity;
  final Function done;
//final String uid;

  const Newtransaction(this.opacity, this.done);

  @override
  _NewtransactionState createState() => _NewtransactionState();
}

class _NewtransactionState extends State<Newtransaction> {
  DateTime selectedDate;
  String uid;
  String uname;
  TextEditingController trans_name = new TextEditingController();
  TextEditingController amount = new TextEditingController();
  TextEditingController category =
      new TextEditingController(text: 'Electricity');

//FirebaseUser user;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCategory = _dropdownMenuItems[0].value;
    super.initState();
    this.selectedDate = DateTime.now();
  }

  List<DropdownMenuItem<Category>> buildDropdownMenuItems(List category) {
    List<DropdownMenuItem<Category>> items = List();
    for (Category category in category) {
      items.add(
        DropdownMenuItem(
          value: category,
          child: Text(category.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Category selectedCompany) {
    setState(() {
      _selectedCategory = selectedCompany;
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(5000),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  updateData(String tname, String date, String amount, String category,
      String uname) async {
    FirebaseUser user = await auth.currentUser();
    if (user.providerData[1].providerId == 'google.com') {
      print(user.providerData[1]);
      print("User Name : ${user.displayName}");
      this.uname = user.displayName;
      uid = user.uid;
    } else {
      this.uname = user.uid;
    }

    final CollectionReference vaultCollection = Firestore.instance
        .collection('Transactions')
        .document(uid)
        .collection(user.displayName);
    //final databaseReference = Firestore.instance;
    await vaultCollection.document(DateTime.now().toString()).setData({
      'UID': this.uid,
      'Transaction_Name': tname,
      'Date': date,
      'Amount': amount,
      'Category': _selectedCategory.name
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Expanded(
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
        width: double.infinity,
        padding: EdgeInsets.all(40),
        color: Colors.white.withOpacity(widget.opacity),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 1.5,
                ),
                child: TextFormField(
                  controller: trans_name,
                  readOnly: false,
                  //initialValue: 'App Subscription',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Transaction Name',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: amount,
                      readOnly: false,
                      //  initialValue: '12',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        isDense: true,
                        icon: Icon(
                          Icons.attach_money,
                        ),
                        contentPadding: const EdgeInsets.all(8),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: DropdownButton(
                      icon: Icon(
                        Icons.list,
                      ),
                      value: _selectedCategory,
                      items: _dropdownMenuItems,
                      onChanged: onChangeDropdownItem,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  OutlineButton.icon(
                    borderSide: const BorderSide(
                      width: 1,
                      color: Colors.black,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onPressed: () {
                      _selectDate(context);
                    },
                    icon: Icon(Icons.today),
                    label: Text(
                      DateFormat('MMMM dd, yyyy').format(selectedDate),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  RaisedButton.icon(
                      color: Color.fromRGBO(5, 162, 49, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onPressed: () => {
                            updateData(trans_name.text, selectedDate.toString(),
                                amount.text, category.text, uname),
                            showDialog(
                                context: context,
                                builder: (_) => AssetGiffyDialog(
                                      image: Image.asset(
                                          'assets/gif/checkmark.gif'),
                                      title: Text(
                                        "Sucessful",
                                        style: TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      description: Text(
                                        "Transaction is added successfully",
                                        textAlign: TextAlign.center,
                                      ),
                                      entryAnimation: EntryAnimation.RIGHT,
                                      onlyOkButton: true,
                                      onOkButtonPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(false);
                                        return null;
                                      },
                                    ))
                          },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      label: Text(
                        'ADD',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
