import 'package:cafeapp/Model/Bill_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

class retreive_bill {
  Future<List<bill_model>> bills() async {
    WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
    final database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'bill_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE bills(id INTEGER PRIMARY KEY, name TEXT, price INTEGER)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The items.
    final List<Map<String, dynamic>> maps = await db.query('bills');

    // Convert the List<Map<String, dynamic> into a List<item>.
    return List.generate(maps.length, (i) {
      return bill_model(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
        price: maps[i]['price'] as int,
      );
    });
  }
}
