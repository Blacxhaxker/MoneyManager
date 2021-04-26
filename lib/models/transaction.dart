import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Transaction{
  final String id,title,image,detail;
  final double amount;
  final DateTime date;

  Transaction({@required this.id,@required this.title,@required this.amount,@required this.date,@required this.image,@required this.detail});
}