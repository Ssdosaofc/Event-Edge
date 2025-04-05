
import 'package:dio/dio.dart';
import 'package:event_edge/utils/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../utils/constants.dart';
import '../widgets/cv.dart';
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
  List<Event> allEvents = [];
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  bool isLoading = false;

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Filter Events", style: TextStyle(color:Colors.black,fontSize: 18, fontWeight: FontWeight.bold)),
              ListTile(
                leading: Icon(Icons.attach_money),
                title: Text("Sort by Price (Low to High)"),
                onTap: () {
                  Navigator.pop(context);
                  _filterByPrice();
                },
              ),
              ListTile(
                leading: Icon(Icons.date_range),
                title: Text("Sort by Date (Soonest First)"),
                onTap: () {
                  Navigator.pop(context);
                  _filterByDate();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _filterByPrice() {
    final sorted = List<Event>.from(eventsList)
      ..sort((a, b) => a.price.compareTo(b.price));
    setState(() {
      eventsList = sorted;
    });
  }

  void _filterByDate() {
    final sorted = List<Event>.from(eventsList)
      ..sort((a, b) => a.start.compareTo(b.start));
    setState(() {
      eventsList = sorted;
    });
  }



  Future<List<Event>> _getRecommendations() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await _dio.get(Utils.fetchEventUrl);

      if (response.statusCode == 200 && response.data is List) {
        print('Success: ${response.data}');

        final now = DateTime.now();

        List<Event> fetchedEvents = (response.data as List)
            .map((e) => Event.fromMap(e))
            .where((event) => event.end.isAfter(now))
            .toList();

        setState(() {
          allEvents=fetchedEvents;
          eventsList = fetchedEvents;
        });
      } else {
        print('Failed with status: ${response.statusCode}');
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // print('Error fetching events: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          content: Container(

            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.red,
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline,color: Colors.white,),
                Text(" Error fetching events: $e"),
              ],
            ),
          )));
    }

    return [];
  }
  void _filterEvents(String query) {
    final filtered = allEvents.where((event) =>
        (event.title ?? '').toLowerCase().contains(query.toLowerCase())
    ).toList();

    setState(() {
      searchQuery = query;
      eventsList = filtered;
    });
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
              TabBar(
                labelColor: Colors.orange,
                indicatorColor: orange,
                controller: _tabController,
                tabs: [
                  Tab(text: "Events"),
                  Tab(text: "Analytics"),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 14.0,left: 8,right: 8,bottom: 8),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _filterEvents,
                            decoration: InputDecoration(
                              hintText: "Search by event name",
                              prefixIcon: Icon(Icons.search),
                              suffixIcon: GestureDetector(
                                onTap: (){
                                  _showFilterOptions(context);
                                },
                                  child: Icon(Icons.filter_alt,size: 29,)
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: orange)
                              )
                            ),
                          ),
                        ),
                        Expanded(
                          child: eventsList.isNotEmpty
                              ? ListView.builder(
                            itemCount: eventsList.length,
                            itemBuilder: (context, i) {
                              return CardView(
                                poster: eventsList[i].poster,
                                name: eventsList[i].title,
                                category: eventsList[i].category,
                                address: eventsList[i].address,
                                price: eventsList[i].price,
                                start: eventsList[i].start,
                                end: eventsList[i].end,
                              );
                            },
                          )
                              : Center(child: Text("No events found")),
                        ),
                      ],
                    ),
                    Analytics(),
                  ],
                ),
              ),
            ],
        )
        );
    }
}