class Item {
  final int id;
  final String item_name;
  final int price;
  final int quantity;

  const Item({
    required this.id,
    required this.item_name,
    required this.price,
    required this.quantity,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item_name': item_name,
      'price': price,
      'quantity' :quantity
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Item{id: $id, item_name: $item_name, price: $price, quantity:$quantity}';
  }
}