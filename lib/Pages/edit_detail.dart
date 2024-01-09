import 'dart:io';

import 'package:cafeapp/Model/item_model.dart';
import 'package:cafeapp/Pages/HomePage.dart';
import 'package:cafeapp/Services/retrieve_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

int id = 0;
String _item_name = "";
int _price = 0;
int _quantity = 0;

class Edit_Item extends StatefulWidget {
  Edit_Item(int index,String name,int price,int quanity) {
    id = index;
    _item_name=name;
    _price=price;
    _quantity=quanity;
  }
  @override
  State<Edit_Item> createState() => _Edit_ItemState();
}

class _Edit_ItemState extends State<Edit_Item> {
  TextEditingController n=TextEditingController(text: _item_name.toString());
  TextEditingController p=TextEditingController(text: _price.toString());
  TextEditingController q=TextEditingController(text: _quantity.toString());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffC52031),
        title: Text('Edit Item',
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
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
                controller: n,
                onChanged: (value) => _item_name = value,
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
                      hintText: "Enter quantity in pcs.")
              ),

              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
            ),
            Container(
                child: Text(
                  "Item Price",
                    style: GoogleFonts.archivo(
                        color: Colors.grey.shade800,
                        fontSize: 20,
                        fontWeight: FontWeight.w800)),
                margin: EdgeInsets.fromLTRB(20, 10, 10, 0),
                alignment: Alignment.bottomLeft),
            Container(
              child: TextField(
                controller: p,
                keyboardType: TextInputType.number,
                onChanged: (value) => _price = int.parse(value),
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
                      hintText: "Enter quantity in pcs.")
              ),
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            ),
            Container(
                child: Text(
                  "Item Quantity",                  style: GoogleFonts.archivo(
                    color: Colors.grey.shade800,
                    fontSize: 20,
                    fontWeight: FontWeight.w800),

                ),
                margin: EdgeInsets.fromLTRB(20, 10, 10, 0),
                alignment: Alignment.bottomLeft),
            Container(
              child: TextField(
                controller: q,
                keyboardType: TextInputType.number,
                onChanged: (value) => _quantity = int.parse(value),
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
                      hintText: "Enter quantity in pcs.")
              ),
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffC52031),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),padding: EdgeInsets.all(10)),
                onPressed: () {
                  if (_item_name != "" && _price != 0 && _quantity != null) {
                    opendatabase_item(Item(
                        id: id,
                        item_name: _item_name,
                        price: _price,
                        quantity: _quantity));
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
                    children: [Icon(Icons.add), Text("Save")],
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

  Future<void> opendatabase_item(item) async {
    WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
    var db;
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      final databaseFactory = databaseFactoryFfi;
      final appDocumentsDir = await getApplicationDocumentsDirectory();
      final dbPath = join(appDocumentsDir.path, "databases", "menu_database.db");
      final winLinuxDB = await databaseFactory.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate:(db, version) {
            // Run the CREATE TABLE statement on the database.
            return db.execute(
              'CREATE TABLE items(id INTEGER PRIMARY KEY, item_name TEXT, price INTEGER,quantity INTEGER)',
            );
          } ,
        ),
      );
      db=winLinuxDB;
    } else if (Platform.isAndroid || Platform.isIOS) {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, "menu_database.db");
      final iOSAndroidDB = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          // Run the CREATE TABLE statement on the database.
          return db.execute(
            'CREATE TABLE items(id INTEGER PRIMARY KEY, item_name TEXT, price INTEGER,quantity INTEGER)',
          );
        },
      );
      db=iOSAndroidDB;
    }

//     final db = openDatabase(
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
    updateitem(item, db);
  }
  Future<void> updateitem(Item item, database) async {
    // Get a reference to the database.
    final db = await database;
    // Update the given Dog.
    await db.update(
      'items',
      item.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [item.id],
    );
  }
}
