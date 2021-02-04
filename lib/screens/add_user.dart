import 'dart:convert';
import 'dart:io';

import 'package:code_test_flutter/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

Box usersBox;

class _AddUserState extends State<AddUser> {
  @override
  void initState() {
    super.initState();
    usersBox = Hive.box('usersBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add user'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: AddUserForm(),
        ),
      ),
    );
  }
}

enum ProductType { product, service }
enum AmountType { cash, online, gpay }

class AddUserForm extends StatefulWidget {
  @override
  _AddUserFormState createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  final _formKey = GlobalKey<FormState>();
  ProductType productType;
  bool productTypeError = false;
  AmountType amountType;
  bool amountTypeError = false;
  DateTime selectedDate;
  bool dateError = false;
  File _image;
  bool imageError = false;
  File _storedImage;
  String imageTitle;
  String name;
  String mobile;
  String amount;
  String imgPath;

  // File demoBg =
  //     File('/data/user/0/com.sahillimbe.code_test_flutter/app_flutter/sahil');
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        saveImage();
      } else {
        print('No image selected.');
      }
    });
  }

  Future saveImage() async {
    Directory appDocumentsDirectory = await getExternalStorageDirectory();
    String path = appDocumentsDirectory.path;
    debugPrint('$path/$imageTitle');
    imgPath = '$path/$imageTitle';
    _storedImage = await _image.copy('$path/$imageTitle');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter Name',
              labelText: 'Name',
            ),
            onChanged: (value) {
              name = value;
              imageTitle = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Required field';
              }
              return null;
            },
          ),
          SizedBox(
            height: 18,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: 'Enter Mobile Number',
              labelText: 'Mobile Number',
            ),
            onChanged: (value) {
              mobile = value;
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Required field';
              }
              return null;
            },
          ),
          SizedBox(
            height: 32,
          ),
          // FormBuilderRadioGroup(),
          Text(
            'Product Type:',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          ListTile(
            title: Text('Product'),
            leading: Radio(
              value: ProductType.product,
              groupValue: productType,
              onChanged: (ProductType value) {
                setState(
                  () {
                    productType = value;
                  },
                );
                debugPrint(productType.toString());
              },
            ),
          ),
          ListTile(
            title: Text('Service'),
            leading: Radio(
              value: ProductType.service,
              groupValue: productType,
              onChanged: (ProductType value) {
                setState(
                  () {
                    productType = value;
                  },
                );
                debugPrint(productType.toString());
              },
            ),
          ),
          SizedBox(
            height: 8,
          ),
          productTypeError == true
              ? Text(
                  'You must select a product type',
                  style: TextStyle(fontSize: 13, color: (Color(0xFFDD2C00))),
                )
              : SizedBox(
                  height: 0,
                ),
          SizedBox(
            height: 18,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: 'Enter Amount',
              labelText: 'Amount in ₹',
            ),
            onChanged: (value) {
              amount = value;
            },
            validator: (amountValue) {
              if (amountValue.isEmpty) {
                return 'Required field';
              }
              return null;
            },
          ),
          SizedBox(
            height: 32,
          ),
          Text(
            'Amount Type:',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          ListTile(
            title: Text('Cash'),
            leading: Radio(
              value: AmountType.cash,
              groupValue: amountType,
              onChanged: (AmountType value) {
                setState(
                  () {
                    amountType = value;
                  },
                );
                debugPrint(amountType.toString());
              },
            ),
          ),
          ListTile(
            title: Text('Online'),
            leading: Radio(
              value: AmountType.online,
              groupValue: amountType,
              onChanged: (AmountType value) {
                setState(
                  () {
                    amountType = value;
                  },
                );
                debugPrint(amountType.toString());
              },
            ),
          ),
          ListTile(
            title: Text('Gpay'),
            leading: Radio(
              value: AmountType.gpay,
              groupValue: amountType,
              onChanged: (AmountType value) {
                setState(
                  () {
                    amountType = value;
                  },
                );
                debugPrint(amountType.toString());
              },
            ),
          ),
          SizedBox(
            height: 8,
          ),
          amountTypeError == true
              ? Text(
                  'You must select an amount type',
                  style: TextStyle(fontSize: 13, color: (Color(0xFFDD2C00))),
                )
              : SizedBox(
                  height: 0,
                ),
          SizedBox(
            height: 18,
          ),
          Row(
            children: [
              Text(
                'Pick a date:',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              RaisedButton(
                child: Text(
                  selectedDate == null
                      ? 'No date selected'
                      : DateFormat.yMMMd().format(selectedDate).toString(),
                ),
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2015),
                    lastDate: DateTime.now(),
                  ).then((date) {
                    setState(() {
                      selectedDate = date;
                    });
                    debugPrint(DateFormat.yMMMd().format(selectedDate));
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          dateError == true
              ? Text(
                  'You must pick a date',
                  style: TextStyle(fontSize: 13, color: (Color(0xFFDD2C00))),
                )
              : SizedBox(
                  height: 0,
                ),
          SizedBox(
            height: 18,
          ),
          // Center(
          //   child: Container(
          //     color: Colors.red[300],
          //     width: MediaQuery.of(context).size.width * 0.7,
          //     height: 140,
          //     child: Image.file(demoBg),
          //   ),
          // ),
          Center(
            child: Container(
              color: Colors.grey[300],
              width: MediaQuery.of(context).size.width * 0.7,
              height: 140,
              child: _image == null
                  ? Center(
                      child: Text('No Image Selected.'),
                    )
                  : Image.file(_image),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text(
                'Select an image:',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              RaisedButton(
                child: Text('Open Gallery'),
                onPressed: getImage,
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          imageError == true
              ? Text(
                  'You must select an image',
                  style: TextStyle(fontSize: 13, color: (Color(0xFFDD2C00))),
                )
              : SizedBox(
                  height: 0,
                ),
          SizedBox(
            height: 18,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_image == null) {
                  setState(() {
                    imageError = true;
                  });
                } else {
                  setState(() {
                    imageError = false;
                  });
                }
                if (selectedDate == null) {
                  setState(() {
                    dateError = true;
                  });
                } else {
                  setState(() {
                    dateError = false;
                  });
                }
                if (productType == null) {
                  setState(() {
                    productTypeError = true;
                  });
                } else {
                  setState(() {
                    productTypeError = false;
                  });
                }
                if (amountType == null) {
                  setState(() {
                    amountTypeError = true;
                  });
                } else {
                  setState(() {
                    amountTypeError = false;
                  });
                }
                if (_formKey.currentState.validate() &&
                    !imageError &&
                    !dateError &&
                    !productTypeError &&
                    !amountTypeError) {
                  debugPrint('Everything seems good');
                  debugPrint('Name: ' + name.toString());
                  debugPrint('Mobile: ' + mobile.toString());
                  debugPrint('ProductType: ' + productType.toString());
                  debugPrint('Amount: ' + amount.toString());
                  debugPrint('AmountType: ' + amountType.toString());
                  debugPrint('SelectedDate: ' +
                      DateFormat.yMMMd().format(selectedDate).toString());

                  User addUser = User(
                    imgPath.toString(),
                    name.toString(),
                    mobile.toString(),
                    productType.toString(),
                    selectedDate.toString(),
                    int.parse(amount),
                    amountType.toString(),
                  );

                  usersBox.add(jsonEncode(addUser));
                  Navigator.pop(context);
                }
              },
              child: Text('Submit'),
            ),
          )
        ],
      ),
    );
  }
}
