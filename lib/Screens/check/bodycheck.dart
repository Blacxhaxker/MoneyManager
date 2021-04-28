import 'dart:convert';

import 'dart:ui';
import 'package:Final_Project/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Final_Project/models/transaction.dart';
import 'package:Final_Project/Screens/MainApp/components/transaction_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:money/screen/MainApp/chart.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool shouldShowChart = false;
  DateTime _selectedDate;

  final List<Transaction> _transactionLIst = [];
  List<Transaction> _transactionLIst2 = [];

  // List<Transaction> get _recentTransactions
  // {
  //   return _transactionLIst.where((transaction)
  // {
  //     return transaction.date.isAtSameMomentAs(_selectedDate);
  //   }).toList();
  // }

  void _popDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(hours: 1)),
      firstDate: DateTime(2019),
      lastDate: DateTime(2500),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    ).then((pickedDate) async {
      if (pickedDate == null) return;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Transaction> test = <Transaction>[];
      for (var i in prefs.get("arrayObj")) {
        var data = Transaction.fromJson(json.decode(i));
        if (data.date == pickedDate.toString()) test.add(data);
      }
      _transactionLIst2.clear();
      setState(() {
        _selectedDate = pickedDate;
        _transactionLIst2.addAll(test.toList());
      });
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactionLIst.retainWhere((transaction) => transaction.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    Container(
      margin: EdgeInsets.all(10),
      child: TransactionList(_transactionLIst, _deleteTransaction),
    );
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 3,
              child: Column(
                children: <Widget>[
                  Text(
                    "เช็ครายการ",
                    style: TextStyle(
                        fontSize: 36,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "เลือกวันที่เพื่อดูรายการทั้งหมด",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                    ),
                  ),
                  Divider(),
                  // ignore: deprecated_member_use
                  Container(
                    height: 70,
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(_selectedDate == null
                                ? 'กรุณาเลือกวันที่!'
                                : "วันที่ " +
                                    DateFormat.yMd().format(_selectedDate))),
                        // ignore: deprecated_member_use
                        FlatButton(
                          onPressed: _popDatePicker,
                          textColor: Theme.of(context).primaryColor,
                          child: Text(
                            'เลือกวันที่  ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _transactionLIst2.length <= 0
                      ? Text("ไม่มีข้อมูล")
                      : Row(children: <Widget>[
                          Expanded(
                              child: SizedBox(
                            height: 200.0,
                            child: ListView.builder(
                              itemCount: _transactionLIst2.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        '${_transactionLIst2[index].image}'),
                                    backgroundColor: Colors.transparent,
                                    radius: 30,
                                  ),
                                  title: Text(
                                    _transactionLIst2[index].title,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: kPrimaryColor,
                                    ),
                                  ),

                                  trailing: Text(
                                    DateFormat("      dd/MM/yyyy").format(
                                        DateTime.parse(
                                            _transactionLIst2[index].date)),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: Colors.grey),
                                  ),

                                  subtitle: Text(
                                    "${_transactionLIst2[index].expen} - "+"\$ ${_transactionLIst2[index].amount}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: Colors.grey),
                                  ),

                                  // ignore: deprecated_member_use

                                  // Text('${_transactionLIst2[index].title}'),
                                );
                              },
                            ),
                          ))
                        ])
                ],
              ))
        ],
      ),
    );
  }
}
