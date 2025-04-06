import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:event_edge/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_treemap/treemap.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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

  Map<String, int> buyGroups = {};
  List<ChartData> heatmapData = [];

  Event? event;

  Future<void> _getEventDetails() async {
    try {
      setState(() {
        isLoading = true;
      });

      print(widget.eventID);

      final response = await _dio.get("http://10.1.49.105:4006/api/events/${widget.eventID}");
      final user_response = await _dio.get("http://10.1.49.105:4006/api/customers");

      if (response.statusCode == 200) {
        print('Success: ${response.data}');
        print('Success: ${user_response.data}');
        setState(() {
          event = Event.fromMap(response.data);


          List<dynamic> usersJson = user_response.data['users'];
          print(usersJson);
          typeGrouped = getTicketTypeCounts(usersJson);
          typeData = convertToChartData(typeGrouped);
          print(typeData);

          buyGroups = getBuyTimeGroups(usersJson);
          print(buyGroups);
          // heatmapData = convertToChartData(buyGroups);

          heatmapData = [
            ChartData('6PM-12AM', 10),
            ChartData('12PM-6PM', 20),
            ChartData('12AM-6AM', 5),
          ];
          print(heatmapData);
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
  void generateOrdersReport(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            buildEventDetailsText(),
            buildTicketTypeDistribution(),
            buildSalesHeatmap(),
          ],
        );
      },
    ));

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/event_report.pdf');
    await file.writeAsBytes(await pdf.save());

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  pw.Widget buildEventDetailsText() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Event Details', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 20),
        pw.Text('Event ID: ${widget.eventID}', style: pw.TextStyle(fontSize: 18)),
        pw.Text('Sold: ${event!.sold}', style: pw.TextStyle(fontSize: 18)),
        pw.Text('Refunded: ${event!.refunded}', style: pw.TextStyle(fontSize: 18)),
        pw.Text('Remaining: ${event!.tickets - event!.sold - event!.refunded}', style: pw.TextStyle(fontSize: 18)),
        pw.SizedBox(height: 20),
      ],
    );
  }

  pw.Widget buildTicketTypeDistribution() {
    return pw.Column(
      children: [
        pw.Text('Ticket Type Distribution', style: pw.TextStyle(fontSize: 22)),
        for (var entry in typeData)
          pw.Text('${entry.label}: ${entry.value}', style: pw.TextStyle(fontSize: 18)),
      ],
    );
  }

  pw.Widget buildSalesHeatmap() {
    return pw.Column(
      children: [
        pw.Text('Sales Heatmap', style: pw.TextStyle(fontSize: 22)),
        for (var entry in heatmapData)
          pw.Text('${entry.label}: ${entry.value}', style: pw.TextStyle(fontSize: 18)),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _getEventDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Event Analysis",style: GoogleFonts.poppins(fontWeight: FontWeight.w500),)),
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
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: SfCircularChart(
                      title: ChartTitle(text: 'Ticket Type Distribution',textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w500)),
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
              SizedBox(height: 20,),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 5,
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text("Sales Heatmap",style: GoogleFonts.poppins(fontSize: 25,fontWeight: FontWeight.w500),),
                          SizedBox(height: 15,),
                          SfTreemap(
                            dataCount: heatmapData.length,
                            weightValueMapper: (int index) {
                              print("Weight Value: ${heatmapData[index].value}");
                              return heatmapData[index].value.toDouble();
                            },
                            levels: [
                              TreemapLevel(
                                groupMapper: (int index) {
                                  print("Group: ${heatmapData[index].label}");
                                  return heatmapData[index].label;
                                },
                                colorValueMapper: (TreemapTile tile) {
                                  print("Tile Weight: ${tile.weight}");
                                  if (tile.weight <= 5) {
                                    return Colors.deepOrange[100];
                                  } else if (tile.weight <= 15) {
                                    return Colors.deepOrange[300];
                                  } else if (tile.weight <= 50) {
                                    return Colors.deepOrange[700];
                                  }
                                  return Colors.orange;
                                },
                                labelBuilder: (BuildContext context, TreemapTile tile) {
                                  return Center(child: Text('${tile.group}\n${tile.weight.toInt()}'));
                                },
                                tooltipBuilder: (BuildContext context, TreemapTile tile) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('${tile.group}: ${tile.weight.toInt()} users'),
                                  );
                                },
                              )
                            ],
                          ),
                        ],

                      )
                  ),
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: (){
                    generateOrdersReport(context);
                  },
                  child: const Text(
                    "Save data as Pdf",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, int> getTicketTypeCounts(List<dynamic> users) {
    final Map<String, int> typeCounts = {};

    for (var user in users) {
      if (user['eventId'] == widget.eventID) {
        String cat = user['category'];
        typeCounts[cat] = (typeCounts[cat] ?? 0) + 1;
      }
    }

    return typeCounts;
  }

  List<ChartData> convertToChartData(Map<String, int> grouped) {
    return grouped.entries.map((e) => ChartData(e.key, e.value)).toList();
  }

  Map<String, int> getBuyTimeGroups(List<dynamic> users) {
    final Map<String, int> timeGroups = {
      '12AM-6AM': 0,
      '6AM-12PM': 0,
      '12PM-6PM': 0,
      '6PM-12AM': 0,
    };

    for (var user in users) {
      if (user['eventId'] == widget.eventID) {
        int hour = user['buyTime'];

        print('User Buy Time: ${user['buyTime']}');
        if (hour >= 0 && hour < 6) {
          timeGroups['12AM-6AM'] = timeGroups['12AM-6AM']! + 1;
        } else if (hour >= 6 && hour < 12) {
          timeGroups['6AM-12PM'] = timeGroups['6AM-12PM']! + 1;
        } else if (hour >= 12 && hour < 18) {
          timeGroups['12PM-6PM'] = timeGroups['12PM-6PM']! + 1;
        } else {
          timeGroups['6PM-12AM'] = timeGroups['6PM-12AM']! + 1;
        }
      }
    }

    return timeGroups;
  }

}

class ChartData {
  final String label;
  final int value;

  ChartData(this.label, this.value);
}
