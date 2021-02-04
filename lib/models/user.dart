import 'package:intl/intl.dart';

class User {
  final String imgPath;
  final String name;
  final String mobile;
  final String productType;
  final String date;
  final int amount;
  final String amountType;

  User(
    this.imgPath,
    this.name,
    this.mobile,
    this.productType,
    this.date,
    this.amount,
    this.amountType,
  );

  User.fromJson(Map<String, dynamic> json)
      : imgPath = json['imgPath'],
        name = json['name'],
        mobile = json['mobile'],
        productType = json['productType'],
        date = json['date'],
        amount = json['amount'],
        amountType = json['amountType'];

  Map<String, dynamic> toJson() {
    return {
      'imgPath': imgPath,
      'name': name,
      'mobile': mobile,
      'productType': productType,
      'date': date,
      'amount': amount,
      'amountType': amountType
    };
  }
}

User user1 = User(
  '',
  'Natalie Watts',
  '9393939393',
  'Product',
  "2019-07-16 08:40:23",
  200,
  'Cash',
);
User user2 = User(
  '',
  'Gerald Stone',
  '9393939393',
  'Product',
  "2019-07-15 08:40:23",
  400,
  'Cash',
);
User user3 = User(
  '',
  'Camila Lewis',
  '9393939393',
  'Product',
  "2019-07-14 08:40:23",
  1300,
  'Cash',
);
User user4 = User(
  '',
  'Bob Cunningham',
  '9393939393',
  'Product',
  "2019-07-13 08:40:23",
  10,
  'Cash',
);
User user5 = User(
  '',
  'Sherry Steeves',
  '9393939393',
  'Product',
  "2019-07-12 08:40:23",
  5200,
  'Cash',
);
User user6 = User(
  '',
  'Russel Wallace',
  '9393939393',
  'Product',
  "2019-07-11 08:40:23",
  970,
  'Cash',
);

List users = [
  user1,
  user2,
  user3,
  user4,
  user5,
  user6,
];
