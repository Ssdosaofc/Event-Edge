import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

import '../utils/constants.dart';

class RecommendCardView extends StatelessWidget {
  final String poster;
  final String name;
  final double price;
  final String date;
  final String action;

  const RecommendCardView({
    super.key,
    required this.poster,
    required this.name,
    required this.price,
    required this.date,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return  Card(
        color: light,
        elevation: 5,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            width: MediaQuery.of(context).size.width,
            height: 100,
            decoration: BoxDecoration(
                image: DecorationImage(image: MemoryImage(base64Decode('poster')))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 15),),
                    SizedBox(height: 2,),
                    Text("x days left",style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 10),),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Current Price: $price",style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 15),),
                    Text("Recommended action: $action",style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 10),),
                  ],
                ),
              ],
            ),
            ),
        );
    }
}