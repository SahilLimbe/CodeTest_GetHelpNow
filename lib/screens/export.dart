import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class Export extends StatefulWidget {
  @override
  _ExportState createState() => _ExportState();
}

class _ExportState extends State<Export> {
  Box usersBox;
  List<int> selectedIndexes = List<int>();
  @override
  void initState() {
    super.initState();
    usersBox = Hive.box('usersBox');
  }

  dateTimeRangePicker() async {
    setState(() {
      selectedIndexes.clear();
    });

    DateTimeRange picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        end: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        start: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day - 3),
      ),
    );
    for (int i = 0; i < usersBox.length; i++) {
      Map user = jsonDecode(usersBox.getAt(i));
      var date = DateTime.parse(user['date']);
      if (picked.start.isBefore(date) && picked.end.isAfter(date)) {
        print('${user['name']} is in range');
        setState(() {
          selectedIndexes.add(i);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Export'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount:
                    selectedIndexes.length == 0 ? 0 : selectedIndexes.length,
                itemBuilder: (BuildContext context, int i) {
                  Map user = jsonDecode(usersBox.getAt(selectedIndexes[i]));
                  String titleText = '${user['name']} - ${user['mobile']}';
                  DateTime date = DateTime.parse(user['date']);
                  var _image;
                  if (user['imgPath'] != '') {
                    _image = File(user['imgPath']);
                  }
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      child: _image == null
                          ? null
                          : ClipOval(
                              child: Image.file(
                                _image,
                                height: 60,
                                width: 60,
                              ),
                            ),
                    ),
                    title: Text(titleText),
                    subtitle: Text(DateFormat.yMMMd().format(date).toString()),
                    trailing: Text('₹${user['amount'].toString()}'),
                  );
                }),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: RaisedButton(
                    onPressed: () {
                      dateTimeRangePicker();
                    },
                    child: Text("Select a Date Range"),
                  ),
                ),
                Center(
                  child: RaisedButton(
                    onPressed: () {
                      debugPrint('Does not work yet');
                    },
                    child: Text("Export"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
