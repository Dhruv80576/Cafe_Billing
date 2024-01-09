import 'dart:io';

import 'package:cafeapp/Model/Bill_model.dart';
import 'package:cafeapp/Model/bill_item.dart';
import 'package:cafeapp/Model/item_model.dart';
import 'package:cafeapp/Pages/HomePage.dart';
import 'package:cafeapp/Services/retreive_bills.dart';
import 'package:cafeapp/Services/retrieve_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Generatebill extends StatefulWidget {
  const Generatebill({Key? key}) : super(key: key);

  @override
  State<Generatebill> createState() => _GeneratebillState();
}

class _GeneratebillState extends State<Generatebill> {
  List<Item> list_items = [];
  List<BillItem> item_selected = [];
  List<int> list_quantity = [];
  String name = "";
  int bill_no = 0;
  var database_bill;
  var database_item;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_data();
    get_billno();
    opendatabase_bill();
    opendatabase_item();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffC52031),
        title: Text('Generate Bill'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bill Details',
                style: GoogleFonts.archivo(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: Colors.black),
              ),
              Divider(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  'Receipent Name',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              TextField(
                  onChanged: (value) {
                    name = value;
                  },
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
              Divider(
                height: 20,
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text("Bill No.")),
              Container(
                  margin: EdgeInsets.fromLTRB(20, 5, 0, 10),
                  child: Text(
                    '#${(bill_no)}',
                    style: GoogleFonts.archivo(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  )),
              Container(
                child: Text("Select Items"),
                margin: EdgeInsets.all(10),
              ),
              Container(
                height: 220,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Item name",
                            style: GoogleFonts.quicksand(
                                color: Colors.grey.shade600, fontSize: 12),
                          ),
                          Text(
                            list_items[index].item_name,
                            style: GoogleFonts.archivo(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Price",
                            style: GoogleFonts.quicksand(
                                color: Colors.grey.shade600, fontSize: 12),
                          ),
                          Text(
                            "₹${list_items[index].price}",
                            style: GoogleFonts.archivo(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Quantity available",
                            style: GoogleFonts.quicksand(
                                color: Colors.grey.shade600, fontSize: 12),
                          ),
                          Text(
                            '${list_items[index].quantity}',
                            style: GoogleFonts.archivo(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (list_items.elementAt(index).quantity !=
                                        0) {
                                      updateitem(Item(
                                          id: list_items.elementAt(index).id,
                                          item_name: list_items
                                              .elementAt(index)
                                              .item_name,
                                          price:
                                              list_items.elementAt(index).price,
                                          quantity: list_items
                                                  .elementAt(index)
                                                  .quantity -
                                              1));
                                      if (item_selected.length != 0) {
                                        var temp = update_selcted_item(1, index);
                                        if (temp != 1) {
                                          item_selected.add(BillItem(
                                              id: list_items.elementAt(index).id,
                                              item_name: list_items
                                                  .elementAt(index)
                                                  .item_name,
                                              price: list_items
                                                  .elementAt(index)
                                                  .price,
                                              quantity: list_items
                                                  .elementAt(index)
                                                  .quantity,
                                              served_quantity: 1));
                                        }
                                      } else {
                                        item_selected.add(BillItem(
                                            id: list_items.elementAt(index).id,
                                            item_name: list_items
                                                .elementAt(index)
                                                .item_name,
                                            price:
                                                list_items.elementAt(index).price,
                                            quantity: list_items
                                                .elementAt(index)
                                                .quantity,
                                            served_quantity: 1));
                                      }
                                    } else {}
                                  });
                                },
                                icon: Icon(Icons.add),
                              ),
                              checkquantity(list_items.elementAt(index).id) == 0
                                  ? Text("")
                                  : IconButton(
                                      onPressed: () {
                                        if (checkquantity(
                                                list_items.elementAt(index).id) ==
                                            1) {
                                          remove_item(index);
                                        }
                                        update_selcted_item(-1, index);
                                        updateitem(Item(
                                            id: list_items.elementAt(index).id,
                                            item_name: list_items
                                                .elementAt(index)
                                                .item_name,
                                            price:
                                                list_items.elementAt(index).price,
                                            quantity: list_items
                                                    .elementAt(index)
                                                    .quantity +
                                                1));
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ))
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: list_items.length,
                ),
              ),
              Container(
                child: Text('Item selected'),
                margin: EdgeInsets.all(10),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          item_selected.elementAt(index).item_name.toUpperCase(),
                          style: GoogleFonts.archivo(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.black)),
                      trailing: Text(
                        '${item_selected.elementAt(index).served_quantity} * ₹${item_selected.elementAt(index).price} = ₹${item_selected.elementAt(index).price * item_selected.elementAt(index).served_quantity}',
                        style: GoogleFonts.archivo(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                      ),
                    );
                  },
                  itemCount: item_selected.length),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        height: 50,
        color: Color(0xffC52031),
        child: Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                if (bill_no != 0 && name != "" && item_selected.length != 0) {
                  save_bill();
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
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Enter all required fields")));
                }
              },
              child: Text(
                "Generate Bill",
                style: TextStyle(fontSize: 18, color: Color(0xffC52031)),
              ),
            ),
            Spacer(),
            Text(
              "Total Amount:",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade200),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '₹${calculatebill()}',
              style: GoogleFonts.abel(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w800),
            )
          ],
        ),
      ),
    );
  }

  void get_data() async {
    list_items = [];
    List<Item> temp = await retreive_data().items();
    setState(() {
      for (int i = 0; i < temp.length; i++) {
        list_items.add(temp.elementAt(i));
      }
    });
  }

  int calculatebill() {
    int temp = 0;
    for (int i = 0; i < item_selected.length; i++) {
      temp += item_selected.elementAt(i).price *
          item_selected.elementAt(i).served_quantity;
    }
    return temp;
  }

  void save_bill() async {
    await insertItem(
        bill_model(price: calculatebill(), id: bill_no, name: name),
        database_bill);
  }

  Future<void> opendatabase_bill() async {
    WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
    var db;
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      final databaseFactory = databaseFactoryFfi;
      final appDocumentsDir = await getApplicationDocumentsDirectory();
      final dbPath =
      join(appDocumentsDir.path, "databases", "bill_database.db");
      final winLinuxDB = await databaseFactory.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
            version: 1,
            onCreate: (db, version) {
              // Run the CREATE TABLE statement on the database.
              return db.execute(
                'CREATE TABLE bills(id INTEGER PRIMARY KEY, name TEXT, price INTEGER)',
              );
            }),
      );
      db = winLinuxDB;
    } else if (Platform.isAndroid || Platform.isIOS) {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, "bill_database.db");
      final iOSAndroidDB =
      await openDatabase(path, version: 1, onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE bills(id INTEGER PRIMARY KEY, name TEXT, price INTEGER)',
        );
      });
      db = iOSAndroidDB;
    }
    //
    // final db = openDatabase(
    //   // Set the path to the database. Note: Using the `join` function from the
    //   // `path` package is best practice to ensure the path is correctly
    //   // constructed for each platform.
    //   join(await getDatabasesPath(), 'bill_database.db'),
    //   onCreate: (db, version) {
    //     // Run the CREATE TABLE statement on the database.
    //     return db.execute(
    //       'CREATE TABLE bills(id INTEGER PRIMARY KEY, name TEXT, price INTEGER)',
    //     );
    //   },
    //   // Set the version. This executes the onCreate function and provides a
    //   // path to perform database upgrades and downgrades.
    //   version: 1,
    // );
    database_bill = db;
  }

  Future<void> opendatabase_item() async {
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
    database_item = db;
  }

  Future<void> insertItem(bill_model bill, database) async {
    // Get a reference to the database.
    final db = await database;
    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert('bills', bill.toMap());
    print("successfully saved");
  }

  void get_billno() async {
    List<bill_model> temp = await retreive_bill().bills();
    setState(() {
      bill_no = temp.length + 1;
    });
  }

  Future<void> updateitem(Item item) async {
    // Get a reference to the database.
    final db = await database_item;
    // Update the given Dog.
    await db.update(
      'items',
      item.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [item.id],
    );
    get_data();
  }

  int checkquantity(int id) {
    for (int i = 0; i < item_selected.length; i++) {
      if (item_selected.elementAt(i).id == id) {
        return item_selected.elementAt(i).served_quantity;
      }
    }
    return 0;
  }

  int update_selcted_item(int quan, int index) {
    int temp = 0;
    setState(() {
      for (int i = 0; i < item_selected.length; i++) {
        if (list_items.elementAt(index).id == item_selected.elementAt(i).id) {
          item_selected[i] = BillItem(
              id: list_items[index].id,
              item_name: list_items.elementAt(index).item_name,
              price: list_items.elementAt(index).price,
              quantity: list_items.elementAt(index).quantity,
              served_quantity: item_selected[i].served_quantity + quan);
          temp = 1;
        }
      }
    });
    return temp;
  }

  void remove_item(int index) {
    for (int i = 0; i < item_selected.length; i++) {
      if (list_items.elementAt(index).id == item_selected.elementAt(i).id) {
        item_selected.removeAt(i);
      }
    }
  }
}
