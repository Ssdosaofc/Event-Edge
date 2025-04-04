// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'dart:convert';
//
// import '../constants.dart';
//
// class CardView extends StatelessWidget {
//   // String poster;
//   // String name;
//   // String category;
//   // String address;
//   // int price;
//   // String date;
//   // String time;
//
//   CardView({super.key,
//     // required this.poster, required this.name,required this.category,required this.address,
//     // required this.price,required this.date,required this.time
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return  Card(
//       color: light,
//       elevation: 5,
//       child: Container(
//         padding: EdgeInsets.all(10),
//         width: MediaQuery.of(context).size.width,
//         height: 150,
//         decoration: BoxDecoration(
//           image: DecorationImage(image: MemoryImage(base64Decode(poster)))
//         ),
//         child: Column(
//           children: [
//             Text("Diddy",style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 12),),
//             SizedBox(height: 5,),
//             Text(name,style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 12),),
//           ],
//         ),
//       ),
//     );
//   }
// }
