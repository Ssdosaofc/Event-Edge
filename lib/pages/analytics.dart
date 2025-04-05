import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  @override
  Widget build(BuildContext context) {

    // List<dynamic> usersJson = jsonDecode(jsonResponse);

    // Map<String, int> grouped = getAgeGroups(usersJson);
    // List<AgeGroupData> chartData = convertToChartData(grouped);

    // Map<String, int> grouped = getRepeatAttendees(usersJson);
    // List<AttendanceType> attendanceData = convertToPieChartData(grouped);

    // List<MapEntry<String, int>> topStates = getTopStates(usersJson);
    // Widget topStateCards = buildTopStatesCards(topStates);

    // Map<String, int> timeGrouped = getTimeActivity(usersJson);
    // List<TimeActivity> timeActivityData = convertToLineChartData(timeGrouped);

    // final typeGrouped = getTicketTypeCounts(users);
    // final typeData = convertToSourceChartData(sourceGrouped);

    // final sourceGrouped = getSourceCounts(users);
    // final sourceData = convertToSourceChartData(sourceGrouped);

    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        title: ChartTitle(text: ' Age Distribution'),
                        series: <CartesianSeries>[
                          ColumnSeries<ChartData, String>(
                            // dataSource: chartData,
                            xValueMapper: (ChartData data, _) => data.label,
                            yValueMapper: (ChartData data, _) => data.value,
                            name: 'Users',
                            dataLabelSettings: DataLabelSettings(isVisible: true),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width/2-22.5,
                      child: Card(
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: SfCircularChart(
                              title: ChartTitle(text: 'Attendee Types'),
                              legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
                              series: <CircularSeries>[
                                DoughnutSeries<ChartData, String>(
                                  // dataSource: attendanceData, // List<AttendanceType>
                                  xValueMapper: (ChartData data, _) => data.label,
                                  yValueMapper: (ChartData data, _) => data.value,
                                  dataLabelSettings: DataLabelSettings(isVisible: true),
                                )
                              ],
                            )
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width/2-22.5,
                      child: Card(
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text('Top States',style: GoogleFonts.poppins(fontSize:18),),
                                // ...topStates.map((entry) {
                                //   return Card(
                                //     margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                //     elevation: 4,
                                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                //     child: ListTile(
                                //       leading: Icon(Icons.place, color: Colors.blueAccent),
                                //       title: Text(entry.key),
                                //       subtitle: Text('Attendees: ${entry.value}'),
                                //     ),
                                //   );
                                // }).toList()
                              ],
                            )
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child:  SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          child: Padding(
                              padding: EdgeInsets.all(20),
                              child: SfCartesianChart(
                                title: ChartTitle(text: 'User Purchase Time Analysis'),
                                primaryXAxis: CategoryAxis(),
                                primaryYAxis: NumericAxis(),
                                series: <CartesianSeries>[
                                  LineSeries<ChartData, String>(
                                    // dataSource: timeActivityData, // List<TimeActivity>
                                    xValueMapper: (ChartData data, _) => data.label,
                                    yValueMapper: (ChartData data, _) => data.value,
                                    markerSettings: MarkerSettings(isVisible: true),
                                    dataLabelSettings: DataLabelSettings(isVisible: true),
                                  ),
                                ],
                              )

                          ),
                        ),
                      ),

                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child:  SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          child: Padding(
                              padding: EdgeInsets.all(20),
                              child: SfCircularChart(
                                title: ChartTitle(text: 'Ticket Type Distribution'),
                                legend: Legend(isVisible: true),
                                series: <DoughnutSeries<ChartData, String>>[
                                  DoughnutSeries<ChartData, String>(
                                    // dataSource: typeData, // List<TicketData>
                                    xValueMapper: (ChartData data, _) => data.label,
                                    yValueMapper: (ChartData data, _) => data.value,
                                    dataLabelSettings: DataLabelSettings(isVisible: true),
                                    radius: '80%',
                                    innerRadius: '40%',
                                  )
                                ],
                              )
                          ),
                        ),
                      ),

                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child:  SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          child: Padding(
                              padding: EdgeInsets.all(20),
                              child: SfCartesianChart(
                                title: ChartTitle(text: 'Marketing Channel Conversion Tracking'),
                                primaryXAxis: CategoryAxis(
                                  title: AxisTitle(text: 'Source'),
                                ),
                                primaryYAxis: NumericAxis(
                                  title: AxisTitle(text: 'Users Converted'),
                                ),
                                series: <CartesianSeries>[
                                  ColumnSeries<ChartData, String>(
                                    // dataSource: chartData,
                                    xValueMapper: (ChartData data, _) => data.label,
                                    yValueMapper: (ChartData data, _) => data.value,
                                    dataLabelSettings: DataLabelSettings(isVisible: true),
                                    color: Colors.teal,
                                  )
                                ],
                              )

                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}

class ChartData {
  final String label;
  final int value;

  ChartData(this.label, this.value);
}

List<ChartData> convertToChartData(Map<String, int> grouped) {
  return grouped.entries.map((e) => ChartData(e.key, e.value)).toList();
}


Map<String, int> getAgeGroups(List<dynamic> users) {
  final Map<String, int> ageGroups = {
    '18-30': 0,
    '31-40': 0,
    '41-60': 0,
    '60+': 0,
  };

  for (var user in users) {
    int age = user['age'];
    if (age >= 18 && age <= 30) {
      ageGroups['18-30'] = ageGroups['18-30']! + 1;
    } else if (age >= 31 && age <= 40) {
      ageGroups['31-40'] = ageGroups['31-40']! + 1;
    } else if (age >= 41 && age <= 60) {
      ageGroups['41-60'] = ageGroups['41-60']! + 1;
    } else if (age > 60) {
      ageGroups['60+'] = ageGroups['60+']! + 1;
    }
  }

  return ageGroups;
}

Map<String, int> getRepeatAttendees(List<dynamic> users) {
  final Map<String, int> result = {
    'Repeat': 0,
    'Newcomer': 0,
  };

  for (var user in users) {
    int repeat = user['prevHistory'];
    if (repeat == 1) {
      result['Repeat'] = result['Repeat']! + 1;
    } else {
      result['Newcomer'] = result['Newcomer']! + 1;
    }
  }

  return result;
}

List<MapEntry<String, int>> getTopStates(List<dynamic> users) {
  Map<String, int> stateCounts = {};

  for (var user in users) {
    String state = user['state'];
    stateCounts[state] = (stateCounts[state] ?? 0) + 1;
  }

  List<MapEntry<String, int>> sorted = stateCounts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  return sorted.take(3).toList();
}

Map<String, int> getTimeActivity(List<dynamic> users) {
  final Map<String, int> timeBuckets = {
    '12AM-6AM': 0,
    '6AM-12PM': 0,
    '12PM-6PM': 0,
    '6PM-12AM': 0,
  };

  for (var user in users) {
    int hour = user['buyTime'];

    if (hour >= 0 && hour < 6) {
      timeBuckets['12AM-6AM'] = timeBuckets['12AM-6AM']! + 1;
    } else if (hour >= 6 && hour < 12) {
      timeBuckets['6AM-12PM'] = timeBuckets['6AM-12PM']! + 1;
    } else if (hour >= 12 && hour < 18) {
      timeBuckets['12PM-6PM'] = timeBuckets['12PM-6PM']! + 1;
    } else if (hour >= 18 && hour < 24) {
      timeBuckets['6PM-12AM'] = timeBuckets['6PM-12AM']! + 1;
    }
  }

  return timeBuckets;
}

Map<String, int> getTicketTypeCounts(List<dynamic> users) {
  final Map<String, int> typeCounts = {};

  for (var user in users) {
    String cat = user['category'];
    typeCounts[cat] = (typeCounts[cat] ?? 0) + 1;
  }

  return typeCounts;
}

Map<String, int> getSourceCounts(List<dynamic> users) {
  final Map<String, int> sourceCounts = {};

  for (var user in users) {
    String source = user['source'];
    sourceCounts[source] = (sourceCounts[source] ?? 0) + 1;
  }

  return sourceCounts;
}