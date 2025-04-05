import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

import '../utils/constants.dart';

class CV extends StatelessWidget {
  final String poster;
  final String name;
  final String category;
  final String address;
  final int price;
  final String date;
  final String start;
  final String end;

  const CardView({
    super.key,
    required this.poster,
    required this.name,
    required this.category,
    required this.address,
    required this.price,
    required this.date,
    required this.start,
    required this.end,
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
                    Text(category,style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 10),),
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(CupertinoIcons.location_solid,color: Colors.redAccent,),
                            SizedBox(width: 5,),
                            SizedBox(
                              width: 100,
                              child: Text(address,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 10),),
                            ),
                          ],
                        )
                      ],
                    ))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Price: $price",style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 15),),
                    SizedBox(height: 20,),
                    Text(date,style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 10),),
                    Text("$start to $end ",style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 10),),
                  ],
                ),
              ],
            ),
        ),
    );
    }
}