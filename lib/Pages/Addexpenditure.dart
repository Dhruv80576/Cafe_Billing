import 'dart:io';

import 'package:cafeapp/Model/expenditure_model.dart';
import 'package:cafeapp/Pages/Additem.dart';
import 'package:cafeapp/Pages/HomePage.dart';
import 'package:cafeapp/Services/retreive_expenditure.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
class Add_expenditure extends StatefulWidget {
  const Add_expenditure({Key? key}) : super(key: key);
  @override
  State<Add_expenditure> createState() => _Add_expenditureState();
}

class _Add_expenditureState extends State<Add_expenditure> {
  String name="";
  int amount=0;
  int id=0;
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
        title: Text('Add Expenditure'),
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
                  "Detail",
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
                    hintText: "Enter detail about expenditure"),
                onChanged: (value) => name = value,
              ),
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
            ),
            Container(
                child: Text(
                  "Expenditure Amount",
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
                  onChanged: (value) => amount = int.parse(value),
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
              margin: EdgeInsets.fromLTRB(0, 20, 10, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffC52031),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    padding: EdgeInsets.all(10)),
                onPressed: () {
                  if (name != "" && amount != 0) {
                    opendatabase(Expenditure(name: name, amount: amount, id: id));
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
  void opendatabase(expenditure) async {
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
      await db.insert(
        'expenditure',
        expenditure.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print("successfully saved");
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
      await db.insert(
        'expenditure',
        expenditure.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print("successfully saved");
    }
  }

  void get_data() async{
    List<Expenditure> temp=await Retreive_expenditure().expenditures();
    id=temp.length+1;
  }
}
