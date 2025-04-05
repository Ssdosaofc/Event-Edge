import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';

class Recommendations extends StatefulWidget {
  const Recommendations({super.key});

  @override
  State<Recommendations> createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> {
  final Dio _dio = Dio();
  bool isLoading = false;
  String? body;

  Future<void> _getRecommendations() async {

    try {
      setState(() {
        isLoading = true;
      });

      final response = await _dio.get('https://jsonplaceholder.typicode.com/posts/1');

      if (response.statusCode == 200) {
        print('Success: ${response.data}');
        setState(() {
          body = response.data;
        });
      } else {
        print('Failed with status: ${response.statusCode}');
      }

      if (body == null || body!.isEmpty) return;

      Future.delayed(Duration(milliseconds: 1000), () async {

        final response = await _dio.post(
          'http://172.22.17.252:5001/predict',
          data: jsonEncode({'result': body}),
          options: Options(
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );

        String returnBody = response.data['result'] as String;
        setState(() {
          isLoading = false;
        });

        print("Generated successfully: $returnBody");
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
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        recommendationsList.isNotEmpty?
        ListView.builder(itemCount: recommendationsList.length,
            itemBuilder: (context, i){
              return RecommendCardView(poster: recommendationsList[i].poster, name: recommendationsList[i].title,
                price: recommendationsList[i].price, date: recommendationsList[i].timestamp, action: '',
              );
            }):Center(
            child: Text("No recommendations"),
            ),
        );
    }
}