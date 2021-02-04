import 'dart:convert';
import 'dart:io';

import 'package:code_test_flutter/models/user.dart';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'add_user.dart';
import 'export.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Box usersBox;

  @override
  void initState() {
    super.initState();
    usersBox = Hive.box('usersBox');
    debugPrint("usersBox length initially: " + usersBox.length.toString());
    if (usersBox.length == 0) {
      debugPrint('Filling up local DB');
      for (var user in users) {
        usersBox.add(jsonEncode(user));
      }
    }
    debugPrint("usersBox length after checking local db: " +
        usersBox.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CodeTest - GetHelpNow'),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: Icon(Icons.add),
            label: 'Add',
            labelStyle: TextStyle(fontSize: 16.0),
            onTap: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddUser()))
                  .then((value) {
                setState(() {});
              });
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.save_alt),
            label: 'Export',
            labelStyle: TextStyle(fontSize: 16.0),
            onTap: () => {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Export()))
                  .then((value) {
                setState(() {});
              })
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: usersBox.length,
        itemBuilder: (BuildContext context, int i) {
          Map user = jsonDecode(usersBox.getAt(i));
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
        },
      ),
    );
  }
}
