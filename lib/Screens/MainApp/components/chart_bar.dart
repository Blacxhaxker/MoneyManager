import 'package:Final_Project/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String dayOfWeek;
  final double amountSpent, percentSpentOfTotal;

  const ChartBar(this.dayOfWeek, this.amountSpent, this.percentSpentOfTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height * 0.03,
              child: FittedBox(
                  //amount text
                  child: Text('\฿${amountSpent.toStringAsFixed((0))}',
                      style: TextStyle(color: Colors.white)))),
          SizedBox(height: 5),
          Container(
            height: 85, //old version is 60
            width: 10,
            child: Stack(
              children: <Widget>[
                
                Container(
                  decoration: BoxDecoration(
                    //chart bottom layer
                    border: Border.all(color: kPrimaryColor, width: 1.0),
                    color: Color.fromARGB(255, 92, 186, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  //chart top layer
                  heightFactor: percentSpentOfTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 5),
          Text(
            dayOfWeek,
            style: TextStyle(color: Colors.white),
          )
        ],
      );
    });
  }
}
