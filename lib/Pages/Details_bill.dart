import 'package:cafeapp/Model/Bill_model.dart';
import 'package:cafeapp/Services/retreive_bills.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Bill_Details extends StatefulWidget {
  const Bill_Details({Key? key}) : super(key: key);

  @override
  State<Bill_Details> createState() => _Bill_DetailsState();
}

class _Bill_DetailsState extends State<Bill_Details> {
  List<bill_model> bill_list = [];

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
          title: Text('Bill Details'),
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
                                "Invoice NO.",
                                style: GoogleFonts.quicksand(
                                    color: Colors.grey.shade800,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300),
                              ),
                              Text(
                                '#${bill_list.elementAt(index).id}',
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
                                "Receipent Name",
                                style: GoogleFonts.quicksand(
                                    color: Colors.grey.shade800,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300),
                              ),
                              Text(
                                bill_list.elementAt(index).name,
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
                      Text("₹${bill_list.elementAt(index).price}",style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w700),)

                    ],
                  ),
                ));
              },
              itemCount: bill_list.length),
        ));
  }

  void get_data() async {
    List<bill_model> temp = await retreive_bill().bills();
    setState(() {
      for (int i = temp.length - 1; i >= 0; i--) {
        bill_list.add(temp.elementAt(i));
      }
    });
  }
}
