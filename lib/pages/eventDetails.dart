import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:event_edge/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/event.dart';
import '../utils/constants.dart';

class EventDetails extends StatefulWidget {
  final String eventID;
  const EventDetails({super.key, required this.eventID});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  List<Event> eventsList = [];
  final Dio _dio = Dio();
  bool isLoading = true;

  Map<String, int> typeGrouped = {};
  List<ChartData> typeData = [];

  Event? event;

  Future<void> _getEventDetails() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await _dio.get("http://10.1.49.105:4000/api/events/${widget.eventID}");

      if (response.statusCode == 200) {
        print('Success: ${response.data}');
        setState(() {
          event = Event.fromMap(response.data);


          List<dynamic> usersJson = response.data['users']; // Assuming `users` is a list of users
          typeGrouped = getTicketTypeCounts(usersJson);
          typeData = convertToChartData(typeGrouped);
          print(typeData);
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
      print('Error fetching event: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getEventDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Event Details")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : event == null
          ? Center(child: Text("Failed to load event"))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text("Event Analysis", style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 22.5,
                    child: Card(
                      elevation: 5,
                      color: dark,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Text("Sold", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20)),
                            SizedBox(height: 10),
                            Text("${event!.sold}", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 22.5,
                    child: Card(
                      elevation: 5,
                      color: dark,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Text("Refunded", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20)),
                            SizedBox(height: 10),
                            Text("${event!.refunded}", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 22.5,
                child: Card(
                  elevation: 5,
                  color: dark,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Text("Remaining", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20)),
                        SizedBox(height: 10),
                        Text("${event != null ? (event!.tickets - event!.sold - event!.refunded) : '...'}", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: SfCircularChart(
                      title: ChartTitle(text: 'Ticket Type Distribution'),
                      legend: Legend(isVisible: true),
                      series: <DoughnutSeries<ChartData, String>>[
                        DoughnutSeries<ChartData, String>(
                          dataSource: typeData,
                          xValueMapper: (ChartData data, _) => data.label,
                          yValueMapper: (ChartData data, _) => data.value,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          radius: '80%',
                          innerRadius: '40%',
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Group ticket types (categories) from users data
  Map<String, int> getTicketTypeCounts(List<dynamic> users) {
    final Map<String, int> typeCounts = {};

    for (var user in users) {
      if (user['eventID'] == widget.eventID) {
        String cat = user['category'];  // Assuming each user has a 'category' field for ticket types
        typeCounts[cat] = (typeCounts[cat] ?? 0) + 1;
      }
    }

    return typeCounts;
  }

  // Convert the grouped ticket types into chart data
  List<ChartData> convertToChartData(Map<String, int> grouped) {
    return grouped.entries.map((e) => ChartData(e.key, e.value)).toList();
  }
}

class ChartData {
  final String label;
  final int value;

  ChartData(this.label, this.value);
}
