import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

import '../utils/constants.dart';

class CardView extends StatelessWidget {
  final String poster;
  final String name;
  final String category;
  final String address;
  final double price;
  // final String date;
  final String start;
  final String end;
  final VoidCallback? onTap;

  const CardView({
    super.key,
    required this.poster,
    required this.name,
    required this.category,
    required this.address,
    required this.price,
    // required this.date,
    required this.start,
    required this.end,
    this.onTap,
  });

  String _getStatus(String start, String end) {
    final now = DateTime.now();
    final startTime = DateTime.tryParse(start);
    final endTime = DateTime.tryParse(end);

    if (startTime == null || endTime == null) return "Unknown";

    if (now.isAfter(startTime) && now.isBefore(endTime)) {
      return "Live";
    } else if (now.isBefore(startTime)) {
      return "Upcoming";
    } else {
      return "Ended";
    }
  }

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: onTap,
        child: Card(
            color: light,
            elevation: 5,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              width: MediaQuery.of(context).size.width,
              height: 120,
              decoration: BoxDecoration(
                // image: DecorationImage(image: MemoryImage(base64Decode('poster')))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(name,style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 15),
                          maxLines: 2,
                        ),
                      ),
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
                                width: 50,
                                child: Text(address,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 8),),
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
                      Text(
                          _getStatus(start, end),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: _getStatus(start, end) == 'Ended'?Colors.grey[700]:(_getStatus(start, end) == 'Live' ? Colors.red : Colors.green),
                          ),
                      ),
                      Text("Price: $price",style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 15),),
                      SizedBox(height: 20,),
                      Text("Start: $start",style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 10),),
                      Text("End: $end ",style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 10),),
                    ],
                  ),
                ],
              ),
            ),
        ),
        );
    }
}