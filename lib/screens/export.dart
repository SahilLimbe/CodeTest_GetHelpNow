import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    getPath();
  }

  Directory directory;
  getPath() async {
    directory = await getExternalStorageDirectory();
  }

  dateTimeRangePicker() async {
    setState(
      () {
        selectedIndexes.clear();
      },
    );

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
        setState(
          () {
            selectedIndexes.add(i);
          },
        );
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
                  _image = File(
                    user['imgPath'],
                  );
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
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Center(
                    child: RaisedButton(
                      onPressed: () {
                        dateTimeRangePicker();
                      },
                      child: Text("Select a Date Range"),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: RaisedButton(
                        onPressed: () {
                          final File file =
                              File('${directory.path}/my_file.csv');
                          print(directory.path);

                          Map user;
                          String text =
                              'NAME, MOBILE, PRODUCTTYPE, AMOUNTTYPE, AMOUNT, DATE \n';
                          for (int i = 0; i < selectedIndexes.length; i++) {
                            user =
                                jsonDecode(usersBox.getAt(selectedIndexes[i]));
                            text = text +
                                user['name'] +
                                "," +
                                user['mobile'] +
                                "," +
                                user['productType'] +
                                "," +
                                user['amountType'] +
                                "," +
                                user['amount'].toString() +
                                "," +
                                user['date'] +
                                "\n";
                            file.writeAsString(text);
                          }
                          print('CSV file created');
                          return Fluttertoast.showToast(
                              msg:
                                  "CSV file created at \n '${directory.path}/my_file.csv'",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 10,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        },
                        child: Text("Export"),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Center(
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            selectedIndexes.clear();
                          });
                        },
                        child: Text("Clear"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
