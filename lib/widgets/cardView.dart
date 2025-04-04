import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constants.dart';


class CardView extends StatelessWidget {
  const CardView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Card(
      color: light,
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: 150,
        child: Column(
          children: [
            Text('Data',style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 15),)
          ],
        ),
      ),
    );
  }
}