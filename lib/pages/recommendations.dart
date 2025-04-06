import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/event.dart';
import '../widgets/recommendCardView.dart';


class Recommendations extends StatefulWidget {
  const Recommendations({super.key});

  @override
  State<Recommendations> createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> {
  final Dio _dio = Dio();
  bool isLoading = false;
  List<dynamic> body = [];
  List<Event> top_reco = [];
  List<Event> bottom_reco_qty = [];
  List<Event> bottom_reco_rating = [];

  Future<void> _getRecommendations() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await _dio.get('http://10.1.49.105:4006/api/events');

      if (response.statusCode == 200) {
        // print('Success: ${response.data}');
        setState(() {
          body = response.data;
        });
      } else {
        print('Failed with status: ${response.statusCode}');
      }

      Future.delayed(Duration(milliseconds: 1000), () async {

        final response = await _dio.post(
          'http://10.1.49.105:4006/recommend',
          data: jsonEncode({'result': body}),
          options: Options(
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );

        String returnBody = response.data['result']?.toString() ?? 'No result returned';
        setState(() {
          isLoading = false;
        });

        print(returnBody);

        List<dynamic> topEvents = response.data['result']['common_bottom5_final_qty'];
        List<dynamic> bottomEvents = response.data['result']['common_bottom5_rating_final'];
        List<dynamic> bottomEventsRating = response.data['result']['top_5_indices'];

        print("Top Recommendations: $topEvents");
        print("Low Performers: $bottomEvents");
        print("Low Performers: $bottomEventsRating");

        top_reco = _mapTitlesToEvents(topEvents);
        bottom_reco_qty = _mapTitlesToEvents(bottomEvents);
        bottom_reco_rating = _mapTitlesToEvents(bottomEventsRating);
        return returnBody;
      });

    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error uploading image: $e');
    }
  }
  List<Event> recommendationsList = [];

  @override
  void initState() {
    super.initState();
    _getRecommendations();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Top Recommendations',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 15),),
                SizedBox(height: 15,),
                top_reco.isNotEmpty?SizedBox(
                  // width: MediaQuery.of(context).size.width,
                  // height: 570,
                  child: GridView.count(crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: top_reco.map((e){
                        return RecommendCardView(poster: e.poster, name: e.title,
                          price: e.price.toDouble(), date: e.timestamp, action: '', problem: 'Popular',
                        );
                      }).toList()
                  ),
                ):Center(child: Text('No recommendations'),),
                Text('Low Quantity',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 15),),
                SizedBox(height: 15,),
                bottom_reco_qty.isNotEmpty?SizedBox(
                  // height: 570,
                  child: GridView.count(crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: bottom_reco_qty.map((e){
                        return RecommendCardView(poster: e.poster, name: e.title,
                          price: e.price.toDouble(), date: e.timestamp, action: '', problem: 'Low Quantity',
                        );
                      }).toList()
                  ),
                ):Center(child: Text('No recommendations'),),
                Text('Low Ratings',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 15),),
                SizedBox(height: 15,),
                bottom_reco_rating.isNotEmpty?SizedBox(
                  // height: 570,
                  child: GridView.count(crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: bottom_reco_rating.map((e){
                        return RecommendCardView(poster: e.poster, name: e.title,
                          price: e.price.toDouble(), date: e.timestamp, action: '', problem: 'Low Ratings',
                        );
                      }).toList()
                  ),
                ):Center(child: Text('No recommendations'),),
                SizedBox(height: 50,)
              ],
            ),
          ),
        )

    );
  }

  List<Event> _mapTitlesToEvents(List<dynamic> eventsJson) {
    return eventsJson.map((item) => Event.fromMap(item)).toList();
  }

}
