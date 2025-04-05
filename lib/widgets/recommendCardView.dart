import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constants.dart';


class RecommendCardView extends StatefulWidget {
  final String poster;
  final String name;
  final double price;
  final String date;
  final String problem;
  final String action;

  const RecommendCardView({
    super.key,
    required this.poster,
    required this.name,
    required this.price,
    required this.date,
    required this.problem,
    required this.action,
  });

  @override
  State<RecommendCardView> createState() => _RecommendCardViewState();
}

class _RecommendCardViewState extends State<RecommendCardView> {
  final gemini = Gemini.instance;
  String geminiDescription = 'Loading...';

  @override
  void initState() {
    super.initState();
    _generateGeminiDescriptions();
  }

  Future<void> _generateGeminiDescriptions() async {
    try {
      final geminiOutput = await gemini.text(
        'Recommend a solution in 5 to 6 words to an upcoming event like a party or concert facing ${widget.problem}. Give the output in pure text.',
      );
      setState(() {
        geminiDescription = geminiOutput?.output ?? 'No summary available';
      });
    } catch (e) {
      setState(() {
        geminiDescription = 'Error generating description';
      });
      print('Gemini error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: light,
      elevation: 5,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18), maxLines: 3),
            SizedBox(height: 2),
            Text(widget.problem, style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 15)),
            SizedBox(height: 10),
            Text("Current Price: ${widget.price}", style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 10)),
            Text("Recommended action: ${widget.action}", style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 10)),
            SizedBox(height: 6),
            Text(geminiDescription, style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 10), maxLines: 5),
          ],
        ),
      ),
    );
  }
}
