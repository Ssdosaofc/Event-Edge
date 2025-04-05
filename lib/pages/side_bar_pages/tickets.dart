import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/constants.dart';

class Tickets extends StatefulWidget {
  const Tickets({super.key});

  @override
  State<Tickets> createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back)),
            title: Text('Tickets',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 20),),
         ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10,),
            Row(
                children:[
            Text("   Total Tickets : ",style:GoogleFonts.poppins(fontSize: 24,fontWeight: FontWeight.bold)),
                  SizedBox(width: 10,),
                  Text(" 500",style: GoogleFonts.poppins(fontSize: 24,fontWeight: FontWeight.w500),)
            ]
            ),
            Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
          SizedBox(
          width: MediaQuery.of(context).size.width/2 - 22.5,
          child: Card(
            elevation: 5,
            color: dark,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Text("Sold",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 18)),
                  SizedBox(height: 10,),
                  Text("30")
                ],
              ),
            ),
          ),
        ),
                SizedBox(
                  width: MediaQuery.of(context).size.width/2 - 22.5,
                  child: Card(
                    elevation: 5,
                    color: dark,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Text("Refunded ",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 18)),
                          SizedBox(height: 10,),
                          Text("5")
                        ],
                      ),
                    ),
                  ),
                ),
              ],
        ),
      ),
            SizedBox(height: 10,),
            SizedBox(
              width: MediaQuery.of(context).size.width/2 - 22.5,
              child: Card(
                elevation: 5,
                color: dark,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Text("Remaining ",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 18)),
                      SizedBox(height: 10,),
                      Text("475")
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.all(10),
              child: Card(
                elevation: 5,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text("Ticket Analysis",style:GoogleFonts.poppins(fontWeight:FontWeight.bold,fontSize: 22,color: Colors.black54)),
                      SizedBox(height: 12,),

                    ],
                  ),
                ),
              ),
            ),
          ]
      )
    )
    );

  }
}
