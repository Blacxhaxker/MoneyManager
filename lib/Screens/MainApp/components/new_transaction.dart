import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';


class UserModel {
  final String id;
  final DateTime createdAt;
  final String name;
  final String avatar;

  UserModel({this.id, this.createdAt, this.name, this.avatar});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return UserModel(
      id: json["id"],
      createdAt:
          json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      name: json["name"],
      avatar: json["avatar"],
    );
  }

  static List<UserModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => UserModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///this method will prevent the override of toString
  bool userFilterByCreationDate(String filter) {
    return this?.createdAt?.toString()?.contains(filter);
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(UserModel model) {
    return this?.id == model?.id;
  }

  @override
  String toString() => name;
}

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  DateTime _selectedDate;
  UserModel _selectedItemUser;  

  void _submitListItem() {
    final String enteredTitle = _selectedItemUser.name;
    final String enteredDetail = _detailController.text;
    final String enteredImage = _selectedItemUser.avatar;
    final double enteredAmount = double.parse(_amountController.text);
    //some input is empty - stop function here
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addTransaction(enteredTitle, enteredAmount, _selectedDate,enteredImage,enteredDetail);
    //close bottom sheet after adding new transaction
    Navigator.of(context).pop();
  }

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
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: DropdownSearch<UserModel>(
                selectedItem: _selectedItemUser,
                mode: Mode.BOTTOM_SHEET,
                isFilteredOnline: true,
                showClearButton: true,
                showSearchBox: true,
                label: 'Title',
                dropdownSearchDecoration: InputDecoration(
                    filled: true,
                    fillColor:
                        Theme.of(context).inputDecorationTheme.fillColor),
                //autoValidate: true,
                validator: (UserModel u) =>
                    u == null ? "user field is required " : null,
                onFind: (String filter) => getData(filter),
                onChanged: (UserModel data) {
                  print(data);
                  _selectedItemUser = data;
                },
                dropdownBuilder: _customDropDownExample,
                popupItemBuilder: _customPopupItemBuilderExample,
              ),
              // child: TextField(
              //   decoration: InputDecoration(labelText: "Title"),
              //   controller: _titleController,
              //   onSubmitted: (_) => _submitListItem(),
              // ),
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              child: TextField(
                decoration: InputDecoration(labelText: "Detail"),
                controller: _detailController,
                onSubmitted: (_) => _submitListItem(),
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: "Amount"),
                controller: _amountController,
                onSubmitted: (_) => _submitListItem(),
              ),
            ),
            Container(
              height: 70,
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text(_selectedDate == null
                          ? 'No date chosen!'
                          : "Picked date  " +
                              DateFormat.yMd().format(_selectedDate))),
                  FlatButton(
                    onPressed: _popDatePicker,
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      'Choose date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: RaisedButton(
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                onPressed: _submitListItem,
                child: Text("Add transaction"),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _customDropDownExample(
      BuildContext context, UserModel item, String itemDesignation) {
    return Container(
      child: (item?.avatar == null)
          ? ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: CircleAvatar(
                backgroundImage: NetworkImage('https://cdn.icon-icons.com/icons2/2958/PNG/512/bubble_chat_messenger_talk_conversation_icon_185925.png'),
                backgroundColor: Colors.transparent,
              ),
              title: Text("No item selected"),
            )
          : ListTile(
              contentPadding: EdgeInsets.all(5),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(item.avatar),
                backgroundColor: Colors.transparent,
              ),
              title: Text("${item.name}"),
            ),
    );
  }

  Widget _customPopupItemBuilderExample(
      BuildContext context, UserModel item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        selected: isSelected,
        title: Text("${item.name}"),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(item.avatar),
          backgroundColor: Colors.transparent,
          minRadius: 25,
    maxRadius: 30,
        ),
      ),
    );
  }

  Future<List<UserModel>> getData(filter) async {
    var response = await Dio().get(
      "https://608571cdd14a870017577ca9.mockapi.io/user",
      queryParameters: {"filter": filter},
    );

    var models = UserModel.fromJsonList(response.data);
    return models;
  }
}
