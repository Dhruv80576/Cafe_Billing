class Expenditure {
  final String name;
  final int amount;
  final int id;

  Expenditure({required this.name, required this.amount, required this.id});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount
    };
  }
}
