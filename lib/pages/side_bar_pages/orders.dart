import 'package:fl_chart/fl_chart.dart'as fl;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pie_chart/pie_chart.dart';
import 'package:printing/printing.dart';

import '../../models/user.dart';
import '../../utils/constants.dart';

class Orders extends StatelessWidget {
  final List<User> users;
  const Orders({Key? key, required this.users}) : super(key: key);

  void generateOrdersReport(BuildContext context) async {
    final pdfDoc = pw.Document();

    final font = await PdfGoogleFonts.nunitoExtraLight();
    final boldFont = await PdfGoogleFonts.nunitoExtraBold();

    Map<String, int> counts = {};
    Map<String, double> revenueMap = {};
    for (var user in users) {
      counts.update(user.payMethod, (val) => val + 1, ifAbsent: () => 1);
      revenueMap.update(user.payMethod, (val) => val + user.amount.toDouble(), ifAbsent: () => user.amount.toDouble());
    }

    final totalRevenue = users.fold(0, (sum, user) => sum + user.amount);

    pdfDoc.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
          base: font,
          bold: boldFont,
        ),
        build: (pw.Context context) => [
          pw.Text('Orders Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),
          pw.Text('Total Orders: ${users.length}', style: pw.TextStyle(fontSize: 16)),
          pw.Text('Total Revenue: ₹${totalRevenue.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 16)),
          pw.SizedBox(height: 20),
          pw.Text('Order Count by Payment Method:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          ...counts.entries.map((e) => pw.Text('${e.key}: ${e.value} orders')),
          pw.SizedBox(height: 20),
          pw.Text('Revenue by Payment Method:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          ...revenueMap.entries.map((e) => pw.Text('${e.key}: ₹${e.value.toStringAsFixed(2)}')),
        ],
      ),
    );

    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfDoc.save(),
      );
    } catch (e) {
      print("PDF printing failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PDF generation failed. Are you on Web?")));
    }
  }

  @override
  Widget build(BuildContext context) {

    Map<String, int> counts = {};
    Map<String, double> revenueMap = {};
    for (var user in users) {
      counts.update(user.payMethod, (val) => val + 1, ifAbsent: () => 1);
      revenueMap.update(user.payMethod, (val) => val + user.amount.toDouble(), ifAbsent: () => user.amount.toDouble());
    }

    Map<String, double> dataMap = {
      for (var entry in counts.entries) entry.key: entry.value.toDouble()
    };


    return Scaffold(
      appBar :AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        title: Text('Orders',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize:20),),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width/2 - 22.5,
                    child: Card(
                      elevation: 5,
                      color: dark,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Text("Total Orders",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 18)),
                            SizedBox(height: 10,),
                            Text(users.length.toString()),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/2 - 22.5,
                    child: Card(
                      elevation: 5,
                      color: dark,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Text("Total Revenue",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 18)),
                            SizedBox(height: 10,),
                            Text(users.fold(0, (sum, user) => sum + user.amount).toString()),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.all(10),
              child: Card(
                elevation: 5,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text("Payment Methods",style:GoogleFonts.poppins(fontWeight:FontWeight.bold,fontSize: 22,color: Colors.black54)),
                      SizedBox(height: 12,),
                      PieChart(
                        dataMap: dataMap,
                        animationDuration: const Duration(milliseconds: 800),
                        chartType: ChartType.disc,
                        chartRadius: MediaQuery.of(context).size.width / 2.5,
                        legendOptions: const LegendOptions(
                          showLegends: true,
                          legendPosition: LegendPosition.right,
                        ),
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValuesInPercentage: true,
                          showChartValueBackground: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 300,
              child: Card(
                elevation: 5,
                color: Colors.white,
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Revenue by Payment Method",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black54)),
                      SizedBox(height: 16),
                      Expanded(
                        child: fl.BarChart(
                          fl.BarChartData(
                            alignment: fl.BarChartAlignment.spaceAround,
                            maxY: revenueMap.values.reduce((a, b) => a > b ? a : b) + 1000,
                            barTouchData: fl.BarTouchData(enabled: true),
                            titlesData: fl.FlTitlesData(
                              leftTitles: fl.AxisTitles(
                                sideTitles: fl.SideTitles(showTitles: true, reservedSize: 45),
                              ),
                              rightTitles: fl.AxisTitles(
                                sideTitles: fl.SideTitles(showTitles: false),
                              ),
                              topTitles: fl.AxisTitles(
                                sideTitles: fl.SideTitles(showTitles: false),
                              ),
                              bottomTitles: fl.AxisTitles(
                                sideTitles: fl.SideTitles(
                                  showTitles: true,
                                  reservedSize: 42,
                                  getTitlesWidget: (value, meta) {
                                    final keys = revenueMap.keys.toList();
                                    if (value < 0 || value >= keys.length) return Container();
                                    return Transform.rotate(
                                      angle: -0.5,
                                      child: Text(
                                        keys[value.toInt()],
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            borderData: fl.FlBorderData(show: false),
                            gridData: fl.FlGridData(show: true),
                            barGroups: revenueMap.entries.toList().asMap().entries.map((entry) {
                              int index = entry.key;
                              String method = entry.value.key;
                              double amount = entry.value.value;
                              return fl.BarChartGroupData(
                                x: index,
                                barRods: [
                                  fl.BarChartRodData(
                                    toY: amount,
                                    width: 18,
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              );
                            }).toList(),
                            groupsSpace: 14, // Adds spacing between bars
                          ),
                        ),
                      ),

                    ],
                  ),
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
    );
  }
}

