import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/event.dart';
import '../utils/constants.dart';
import 'analytics.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin{
  List<Event> eventsList = [];
  late TabController _tabController;
  final Dio _dio = Dio();
  bool isLoading = false;

  Future<List<Event>> _getRecommendations() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await _dio.get('https://jsonplaceholder.typicode.com/posts/1');
      List<dynamic> data = [];

      if (response.statusCode == 200) {
        print('Success: ${response.data}');
        setState(() {
          data = response.data;
        });
      } else {
        print('Failed with status: ${response.statusCode}');
      }
      setState(() {
        isLoading = false;
      });
      setState(() {
        eventsList = data.map((e) => Event.fromMap(e)).toList();
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error uploading image: $e');
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _getRecommendations();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            children: [
              Container(
                child: TabBar(
                  labelColor: Colors.orange,
                  indicatorColor: orange,
                  controller: _tabController,
                  tabs: [
                    Tab(text: "Events"),
                    Tab(text: "Analytics"),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [

                    eventsList.isNotEmpty?
                    ListView.builder(itemCount: eventsList.length,
                        itemBuilder: (context, i){
                          return CV(
                              poster: eventsList[i].poster, name: eventsList[i].title,
                              category: eventsList[i].category, address: eventsList[i].address,
                              price: eventsList[i].price, date: eventsList[i].timestamp,
                              start: eventsList[i].start, end: eventsList[i].end
                          );
                        }):Center(
                      child:
                      Text("No live events"),
                    ),
                    Analytics()
                  ],
                ),
              ),
            ],
            )
        );
    }
}