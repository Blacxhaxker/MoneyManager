import 'dart:convert';

import 'package:Final_Project/Screens/Login/login_screen.dart';
import 'package:Final_Project/Screens/check/check.dart';
import 'package:flutter/material.dart';
import 'package:Final_Project/Screens/MainApp/components/chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './components/transaction_list.dart';
import './components/new_transaction.dart';
import 'package:Final_Project/models/transaction.dart';
import 'package:Final_Project/constants.dart';
import 'package:Final_Project/GoogleService.dart';

class MainAppScreen extends StatefulWidget {
  @override
  _MainAppScreenState createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool shouldShowChart = false;

  final List<Transaction> _transactionLIst = [
    // Transaction(id: "my id", title: "title", amount: 20.0, date: DateTime.now()),
    // Transaction(id: "my id", title: "title", amount: 20.0, date: DateTime.now())
  ];

  List<Transaction> get _recentTransactions {
    return _transactionLIst.where((transaction) {
      return DateTime.parse(transaction.date)
          .isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String title, double amount, String chosenDate , String image, String expen) async{
    Transaction newTransaction = Transaction(
        title: title,
        amount: amount,
        date: chosenDate,
        image: image,
        expen : expen,
        id: DateTime.now().toString());
    setState(() {
      _transactionLIst.add(newTransaction);
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var testEncoded =
        _transactionLIst.map((test) => jsonEncode(test.toJson())).toList();
    await sharedPreferences.setStringList('arrayObj', testEncoded);
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactionLIst.retainWhere((transaction) => transaction.id == id);
    });
  }

  void startAddingNewTransaction(BuildContext buildContext) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    final transactionListWidget = Container(
      margin: EdgeInsets.all(10),
      child: TransactionList(_transactionLIst, _deleteTransaction),
    );
    var scaffold = Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Money Manager",
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
        elevation: 10,
        backgroundColor: kPrimaryColor,
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: kPrimaryColor,
              ),
              accountName: Text(name),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  imageUrl,
                ),
                radius: 60,
                backgroundColor: Colors.transparent,
              ),
            ),
            ListTile(
              leading: Icon(Icons.monetization_on),
              tileColor: kSecondColor,
              title: Text('เช็ครายการ'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return Check();
                  }),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              tileColor: kSecondColor,
              title: Text('LOGOUT'),
              onTap: () {
                signOutGoogle();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                  return LoginScreen();
                }), ModalRoute.withName('/'));
              },
            ),
            Divider(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: kSecondColor,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (isLandscape)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Show charts"),
                    Switch(
                      value: shouldShowChart,
                      onChanged: (value) {
                        setState(() {
                          shouldShowChart = value;
                        });
                      },
                    ),
                  ],
                ),
              if (!isLandscape)
                Chart(
                  recentTransactions: _recentTransactions,
                ),
              if (!isLandscape) transactionListWidget,
              if (isLandscape)
                shouldShowChart
                    ? Chart(
                        recentTransactions: _recentTransactions,
                      )
                    : transactionListWidget,
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          setState(() {
            startAddingNewTransaction(context);
          });
        },
        child: new Icon(Icons.add),
      ),
    );
    return MaterialApp(
      //main ui
      debugShowCheckedModeBanner: false,
      title: 'Money manager',
      home: scaffold,
    );
  }
}
