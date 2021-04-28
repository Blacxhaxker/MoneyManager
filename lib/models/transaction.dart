import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Transaction{
  final String id,title,image,expen;
  final double amount;
  final String date;

  Transaction({
    @required this.id,
    @required this.title,
    @required this.amount,
    @required this.date,
    @required this.image,
    @required this.expen});

    factory Transaction.fromJson(Map<String, dynamic> parsedJson) {
    return new Transaction(
      id: parsedJson['id'] ?? "",
      title: parsedJson['title'] ?? "",
      amount: parsedJson['amount'] ?? "",
      date: parsedJson['date'],
      image: parsedJson['image'] ?? "",
      expen: parsedJson['expen'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": this.id,
      "title": this.title,
      "amount": this.amount,
      "date": this.date,
      "image": this.image,
      "expen": this.expen
    };
  }
}