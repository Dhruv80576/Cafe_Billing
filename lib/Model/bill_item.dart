class BillItem {
  final int id;
  final String item_name;
  final int price;
  final int quantity;
  final int served_quantity;

  const BillItem(
      {required this.id,
      required this.item_name,
      required this.price,
      required this.quantity,
      required this.served_quantity});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item_name': item_name,
      'price': price,
      'quantity': quantity,
      'served_quantity': served_quantity
    };
  }
}
