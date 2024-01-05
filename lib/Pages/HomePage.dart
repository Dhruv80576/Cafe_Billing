import 'package:cafeapp/Model/item_model.dart';
import 'package:cafeapp/Pages/Additem.dart';
import 'package:cafeapp/Pages/Details_bill.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'generate_bill_page.dart';

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
        title: Text('Delhi cafe',
            style:
                GoogleFonts.dancingScript(color: Colors.white, fontSize: 25)),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Bill_Details(),));
          }, icon: Icon(Icons.restaurant_menu))
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
                              alignment: Alignment.center)
                          : Container(
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
                            ));
            },
            itemCount: list_item.length == 0 ? 3 : list_item.length + 2),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Generatebill(),
                ));
          },
          label: Text('Generate Bill')),
    );
  }

  Future<List<Item>> items() async {
    WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
    final database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'menu_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE items(id INTEGER PRIMARY KEY, item_name TEXT, price INTEGER,quantity INTEGER)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    // Get a reference to the database.
    final db = await database;

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
