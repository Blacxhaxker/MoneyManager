
import 'package:Final_Project/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Final_Project/models/transaction.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {

  final List<Transaction> recentTransactions;

  Chart({this.recentTransactions});

  List<Map<String, Object>> get allTransactions {
    return List.generate(7, (index) {
      //subtract index times day from current day
      final weekDay = DateTime.now().subtract(Duration(days: index));

      double totalSum = 0.0;//check output
      
      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
          //todo check why this is being received 15 times and not 1
          print("total sum is " + totalSum.toString());
        }
      }

      //return map to the generate method
      return {
        // 'day': DateFormat.E().format(weekDay).substring(0, 1),
        'day': DateFormat(DateFormat.ABBR_WEEKDAY).format(weekDay),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  
  double get getTotalWeekSpending {
    //0.0 starting value
    return allTransactions.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kPrimaryColor,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      margin: EdgeInsets.all(20),
      child: Padding(
        padding:
            EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0, bottom: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: allTransactions.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  data['day'],
                  data['amount'],
                  getTotalWeekSpending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / getTotalWeekSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
