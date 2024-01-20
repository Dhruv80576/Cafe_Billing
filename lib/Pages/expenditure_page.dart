import 'package:cafeapp/Model/expenditure_model.dart';
import 'package:cafeapp/Services/retreive_bills.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cafeapp/Services/retreive_expenditure.dart';

class Expenditure_Page extends StatefulWidget {
  const Expenditure_Page({Key? key}) : super(key: key);
  @override
  State<Expenditure_Page> createState() => _Expenditure_PageState();
}
class _Expenditure_PageState extends State<Expenditure_Page> {
  List<Expenditure> expenditure_lst=[];
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
          title: Text('Expenditure Details'),
        ),
        body: Container(
          child: ListView.builder(
              itemBuilder: (context, index) {
                return (Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                "EXPENDITURE NO.",
                                style: GoogleFonts.quicksand(
                                    color: Colors.grey.shade800,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300),
                              ),
                              Text(
                                '#${expenditure_lst.elementAt(index).id}',
                                style: GoogleFonts.quicksand(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: [
                              Text(
                                "Details",
                                style: GoogleFonts.quicksand(
                                    color: Colors.grey.shade800,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300),
                              ),
                              Text(
                                expenditure_lst.elementAt(index).name,
                                style: GoogleFonts.quicksand(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Text("Total Amount",style: GoogleFonts.quicksand(
                          color: Colors.grey.shade800,
                          fontSize: 20,
                          fontWeight: FontWeight.w300),),
                      Text("₹${expenditure_lst.elementAt(index).amount}",style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w700),)

                    ],
                  ),
                ));
              },
              itemCount: expenditure_lst.length),
        ));

  }
  void get_data() async {
    List<Expenditure> temp = await Retreive_expenditure().expenditures();
    setState(() {
      for (int i = temp.length - 1; i >= 0; i--) {
        expenditure_lst.add(temp.elementAt(i));
      }
    });
  }
}
