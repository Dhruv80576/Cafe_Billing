import 'package:cafeapp/Model/bill_item.dart';

class bill_model {
  final int price;
  final int id;
  final String name;

  bill_model({required this.price,required this.id,required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}
