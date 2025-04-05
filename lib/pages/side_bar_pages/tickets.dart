import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    );

  }
}
