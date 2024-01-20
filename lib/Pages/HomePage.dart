import 'dart:io';

import 'package:cafeapp/Model/item_model.dart';
import 'package:cafeapp/Pages/Addexpenditure.dart';
import 'package:cafeapp/Pages/Additem.dart';
import 'package:cafeapp/Pages/Details_bill.dart';
import 'package:cafeapp/Pages/edit_detail.dart';
import 'package:cafeapp/Pages/ledger_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'generate_bill_page.dart';
import 'expenditure_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Item> list_item = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffC52031),
        title: Text('Revibes Cafe',
            style:
                GoogleFonts.dancingScript(color: Colors.white, fontSize: 25)),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.restaurant_menu, color: Colors.black),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Bill details")
                    ],
                  ),
                  value: 1,
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.currency_exchange, color: Colors.black),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Expenditure")
                    ],
                  ),
                  value: 2,
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.menu_book_sharp, color: Colors.black),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Ledger")
                    ],
                  ),
                  value: 3,
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.money_off_sharp, color: Colors.black),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Add Expenditure")
                    ],
                  ),
                  value: 4,
                )
              ];
            },
            onSelected: (value) {
              if (value == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Bill_Details(),
                    ));
              } else if (value == 2) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Expenditure_Page()));
              } else if (value == 3) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Ledger_Page()));
              } else if (value == 4) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Add_expenditure()));
              }
            },
          )
        ],
      ),
      body: Container(
        child: ListView.builder(
            itemBuilder: (context, index) {
              return (list_item.length == 0
                  ? index == 0
                      ? Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                          child: Text(
                            "Menu",
                            style: GoogleFonts.archivo(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ))
                      : index == 2
                          ? IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddItem(list_item.length),
                                    ));
                              },
                              icon: Icon(Icons.add),
                              alignment: Alignment.center)
                          : Center(
                              child: Image.asset(
                              'images/menu_image_1.png',
                              width: 50,
                              height: 50,
                            ))
                  : index == 0
                      ? Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                          child: Text(
                            "Menu",
                            style: GoogleFonts.archivo(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ))
                      : index == list_item.length + 1
                          ? IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddItem(list_item.length),
                                    ));
                              },
                              icon: Icon(Icons.add),
                            )
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Edit_Item(
                                          index - 1,
                                          list_item
                                              .elementAt(index - 1)
                                              .item_name,
                                          list_item.elementAt(index - 1).price,
                                          list_item
                                              .elementAt(index - 1)
                                              .quantity),
                                    ));
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                                padding: EdgeInsets.fromLTRB(10, 10, 15, 10),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Item Name',
                                          style: GoogleFonts.quicksand(
                                              color: Colors.grey.shade600,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          '${list_item[index - 1].item_name}',
                                          style: GoogleFonts.archivo(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.start,
                                        ),
                                        Divider(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Quantity:',
                                              style: GoogleFonts.quicksand(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 12),
                                            ),
                                            Text(
                                              '${list_item[index - 1].quantity}',
                                              style: GoogleFonts.archivo(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.start,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      children: [
                                        Text(
                                          'Price',
                                          style: GoogleFonts.quicksand(
                                              color: Colors.grey.shade600,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          '₹${list_item[index - 1].price}',
                                          style: GoogleFonts.archivo(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ));
            },
            itemCount: list_item.length == 0 ? 3 : list_item.length + 2),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color(0xffC52031),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Generatebill(),
                ));
          },
          label: Text(
            'Generate Bill',
            style:
                GoogleFonts.archivo(fontSize: 18, fontWeight: FontWeight.w300),
          )),
    );
  }

  Future<List<Item>> items() async {
    WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
    var db;
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
          },
        ),
      );
      db = winLinuxDB;
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
      db = iOSAndroidDB;
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
    // Get a reference to the database.
    // final db = await database;

    // Query the table for all The items.
    final List<Map<String, dynamic>> maps = await db.query('items');

    // Convert the List<Map<String, dynamic> into a List<item>.
    return List.generate(maps.length, (i) {
      return Item(
          id: maps[i]['id'] as int,
          item_name: maps[i]['item_name'] as String,
          price: maps[i]['price'] as int,
          quantity: maps[i]['quantity'] as int);
    });
  }

  void get_data() async {
    list_item = [];
    List<Item> temp = await items();

    setState(() {
      for (int i = 0; i < temp.length; i++) {
        print('$i\n\n\n\n\n\n');
        list_item.add(temp.elementAt(i));
        print(temp.length);
      }
    });
  }
}
