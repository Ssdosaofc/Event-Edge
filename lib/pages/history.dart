import 'package:dio/dio.dart';
import 'package:event_edge/pages/eventDetails.dart';
import 'package:flutter/material.dart';

import '../models/event.dart';
import '../utils/api.dart';
import '../utils/constants.dart';
import '../widgets/cv.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistroyState();
}

class _HistroyState extends State<History> {
  List<Event> eventsList = [];
  List<Event> allEvents = [];
  final Dio _dio = Dio();
  bool isLoading = false;
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

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
            .where((event) => event.end.isBefore(now))
            .toList();

        setState(() {
          eventsList = fetchedEvents;
          allEvents=fetchedEvents;
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
      print('Error fetching events: $e');
    }
    return [];
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Price: High to Low"),
              onTap: () {
                _sortByPrice(descending: true);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Price: Low to High"),
              onTap: () {
                _sortByPrice(descending: false);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Tickets Sold: High to Low"),
              onTap: () {
                _sortByTicketsSold(descending: true);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Tickets Sold: Low to High"),
              onTap: () {
                _sortByTicketsSold(descending: false);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _sortByPrice({required bool descending}) {
    setState(() {
      eventsList.sort((a, b) =>
      descending ? b.price.compareTo(a.price) : a.price.compareTo(b.price));
    });
  }

  void _sortByTicketsSold({required bool descending}) {
    setState(() {
      eventsList.sort((a, b) => descending
          ? b.sold.compareTo(a.sold)
          : a.sold.compareTo(b.sold));
    });
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
    _getRecommendations();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
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
                          _showFilterOptions();
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
            SizedBox(height: 10),
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
                      onTap: () {
                        print("Tap on Button");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetails(eventID: eventsList[i].id),
                          ),
                        );
                      },
                  );
                },
              )
                  : Center(child: Text("No past events")),
            ),

          ],
        )
    );
  }
}
