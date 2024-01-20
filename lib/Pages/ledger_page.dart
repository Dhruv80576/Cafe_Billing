import 'package:cafeapp/Model/Bill_model.dart';
import 'package:cafeapp/Model/expenditure_model.dart';
import 'package:cafeapp/Services/retreive_bills.dart';
import 'package:cafeapp/Services/retreive_expenditure.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Ledger_Page extends StatefulWidget {
  const Ledger_Page({Key? key}) : super(key: key);
  @override
  State<Ledger_Page> createState() => _Ledger_PageState();
}

class _Ledger_PageState extends State<Ledger_Page> {
  int expenditures = 0;
  int sales = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_sales();
    get_expenditure();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ledger",
        ),
        backgroundColor: Color(0xffC52031),
      ),
      body: Container(
        margin:EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Total Expenditures: ",style: GoogleFonts.archivo(fontWeight:FontWeight.w800,fontSize: 25,color: Colors.grey.shade600),),
                SizedBox(width: 20,),
                Text("₹${expenditures}",style: GoogleFonts.archivo(fontSize: 30,color: Colors.black,fontWeight: FontWeight.w800),),
              ],
            ),
            Row(
              children: [
                Text("Total Sales: ",style: GoogleFonts.archivo(fontWeight:FontWeight.w800,fontSize: 25,color: Colors.grey.shade600)),
                SizedBox(width: 120,),

                Text("₹${sales}",style: GoogleFonts.archivo(fontSize: 30,color: Colors.black,fontWeight: FontWeight.w800)),
              ],
            ),
            Divider(height: 20,),
            sales - expenditures <= 0
                ? Text("Total Loss:\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t₹${expenditures - sales}",style: GoogleFonts.archivo(fontSize: 30,color: Colors.black,fontWeight: FontWeight.w800))
                : Text("Total Profit:\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t₹${sales - expenditures}",style: GoogleFonts.archivo(fontSize: 30,color: Colors.black,fontWeight: FontWeight.w800))
          ],
        ),
      ),
    );
  }

  void get_expenditure() async {
    expenditures = 0;
    List<Expenditure> temp = await Retreive_expenditure().expenditures();
    setState(() {
      for (int i = 0; i < temp.length; i++) {
        expenditures += temp.elementAt(i).amount;
      }
    });
  }

  void get_sales() async {
    sales = 0;
    List<bill_model> temp = await retreive_bill().bills();
    setState(() {
      for (int i = 0; i < temp.length; i++) {
        sales += temp.elementAt(i).price;
      }
    });
  }
}
