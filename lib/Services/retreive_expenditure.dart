import 'dart:io';

import 'package:cafeapp/Model/expenditure_model.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Retreive_expenditure{
  Future<List<Expenditure>> expenditures() async {
    WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
    var db;
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      final databaseFactory = databaseFactoryFfi;
      final appDocumentsDir = await getApplicationDocumentsDirectory();
      final dbPath = join(appDocumentsDir.path, "databases", "expenditure_database.db");
      final winLinuxDB = await databaseFactory.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate:(db, version) {
            // Run the CREATE TABLE statement on the database.
            return db.execute(
              'CREATE TABLE expenditure(id INTEGER PRIMARY KEY, name TEXT, amount INTEGER)',
            );
          } ,
        ),
      );
      db=winLinuxDB;
    } else if (Platform.isAndroid || Platform.isIOS) {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, "expenditure_database.db");
      final iOSAndroidDB = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          // Run the CREATE TABLE statement on the database.
          return db.execute(
            'CREATE TABLE expenditure(id INTEGER PRIMARY KEY, name TEXT, amount INTEGER)',
          );
        },
      );
      db=iOSAndroidDB;
    }
    // final database = openDatabase(
    //   // Set the path to the database. Note: Using the `join` function from the
    //   // `path` package is best practice to ensure the path is correctly
    //   // constructed for each platform.
    //   join(await getDatabasesPath(), 'menu_database.db'),
    //   onCreate: (db, version) {
    //     // Run the CREATE TABLE statement on the database.
    //     return db.execute(
    //       'CREATE TABLE items(id INTEGER PRIMARY KEY, item_name TEXT, price INTEGER,quantity INTEGER)',
    //     );
    //   },
    //   // Set the version. This executes the onCreate function and provides a
    //   // path to perform database upgrades and downgrades.
    //   version: 1,
    // );
    // // Get a reference to the database.
    // final db = await database;
    // Query the table for all The items.
    final List<Map<String, dynamic>> maps = await db.query('expenditure');
    // Convert the List<Map<String, dynamic> into a List<item>.
    return List.generate(maps.length, (i) {
      return Expenditure(
          id: maps[i]['id'] as int,
          name: maps[i]['name'] as String,
          amount: maps[i]['amount'] as int,
          );
    });
  }
}