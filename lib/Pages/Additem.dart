import 'dart:math';

import 'package:cafeapp/Model/item_model.dart';
import 'package:cafeapp/Pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

var id;

class AddItem extends StatefulWidget {
  final id_temp;

  AddItem(this.id_temp) {
    id = this.id_temp;
    print(id);
  }

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  var item_name = '';
  var price;
  var quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffC52031),
        title: Text('Add Item'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
                child: Text(
                  "Item Name",
                  style: GoogleFonts.archivo(
                      color: Colors.grey.shade800,
                      fontSize: 20,
                      fontWeight: FontWeight.w800),
                ),
                margin: EdgeInsets.fromLTRB(20, 10, 10, 0),
                alignment: Alignment.bottomLeft),
            Container(
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xffC52031),
                            width: 2,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    hintText: "Enter item name"),
                onChanged: (value) => item_name = value,
              ),
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
            ),
            Container(
                child: Text(
                  "Item Price",
                  style: GoogleFonts.archivo(
                      color: Colors.grey.shade800,
                      fontSize: 20,
                      fontWeight: FontWeight.w800),
                ),
                margin: EdgeInsets.fromLTRB(20, 10, 10, 0),
                alignment: Alignment.bottomLeft),
            Container(
              child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) => price = int.parse(value),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xffC52031),
                              width: 2,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      hintText: "Price in Rupees")),
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            ),
            Container(
                child: Text(
                  "Item Quantity",
                  style: GoogleFonts.archivo(
                      color: Colors.grey.shade800,
                      fontSize: 20,
                      fontWeight: FontWeight.w800),
                ),
                margin: EdgeInsets.fromLTRB(20, 20, 10, 0),
                alignment: Alignment.bottomLeft),
            Container(
              child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) => quantity = int.parse(value),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xffC52031),
                              width: 2,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      hintText: "Enter quantity in pcs.")),
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 10, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffC52031),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    padding: EdgeInsets.all(10)),
                onPressed: () {
                  if (item_name != "" && price != 0 && quantity != null) {
                    opendatabase(Item(
                        id: id,
                        item_name: item_name,
                        price: price,
                        quantity: quantity));
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Center(
                          child: Container(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              color: Color(0xffC52031),
                            ),
                          ),
                        );
                      },
                    );
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                              (route) => false);
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("None of the field can be empty.")));
                  }
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Icon(Icons.add), Text("Add Item")],
                  ),
                ),
              ),
              alignment: Alignment.bottomCenter,
            )
          ],
        ),
      ),
    );
  }

//   Future<void> opendatabase(item) async {
//     WidgetsFlutterBinding.ensureInitialized();
// // Open the database and store the reference.
//     final database = openDatabase(
//       // Set the path to the database. Note: Using the `join` function from the
//       // `path` package is best practice to ensure the path is correctly
//       // constructed for each platform.
//       join(await getDatabasesPath(), 'menu_database.db'),
//       onCreate: (db, version) {
//         // Run the CREATE TABLE statement on the database.
//         return db.execute(
//           'CREATE TABLE items(id INTEGER PRIMARY KEY, item_name TEXT, price INTEGER,quantity INTEGER)',
//         );
//       },
//       // Set the version. This executes the onCreate function and provides a
//       // path to perform database upgrades and downgrades.
//       version: 1,
//     );
//
//     await insertBill(item, database);
//   }

  Future<Database> opendatabase(item) async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      final databaseFactory = databaseFactoryFfi;
      final appDocumentsDir = await getApplicationDocumentsDirectory();
      final dbPath =
      join(appDocumentsDir.path, "databases", "menu_database.db");
      final winLinuxDB = await databaseFactory.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
            version: 1,
            onCreate: (db, version) {
              // Run the CREATE TABLE statement on the database.
              return db.execute(
                'CREATE TABLE items(id INTEGER PRIMARY KEY, item_name TEXT, price INTEGER,quantity INTEGER)',
              );
            }),
      );
      insertBill(item, winLinuxDB);
    } else if (Platform.isAndroid || Platform.isIOS) {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, "data.db");
      final iOSAndroidDB = await openDatabase(
          path,
          version: 1,
          onCreate: (db, version) {
            // Run the CREATE TABLE statement on the database.
            return db.execute(
              'CREATE TABLE items(id INTEGER PRIMARY KEY, item_name TEXT, price INTEGER,quantity INTEGER)',
            );
          }
      );

      insertBill(item,iOSAndroidDB);
    }
    throw Exception("Unsupported platform"
    );
  }
  Future<void> insertBill(Item item, database) async {
    // Get a reference to the database.
    final db = await database;
    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("successfully saved");
  }
}
