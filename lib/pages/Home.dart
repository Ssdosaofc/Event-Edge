import 'package:event_edge/pages/profile.dart';
import 'package:event_edge/pages/recommendations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sidebarx/sidebarx.dart';

import '../nav_bars/bottom_nav_bar.dart';
import '../nav_bars/side_bar.dart';
import 'addEvent.dart';
import 'dashboard.dart';
import 'histroy.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index=0;
  final pages = [Dashboard(),Recommendations(),History(),Profile()];
  final title = ['Dashboard','Recommendations','History','Profile'];

  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title[index],style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 20),),
        ),
        drawer: Sidebar(controller: _controller),
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: Color(0xFFFFE0B2),
          foregroundColor: Colors.black,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddEvent()));
          },
          child: Icon(Icons.add,weight: 10,),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        extendBody: true,
        bottomNavigationBar: BottomNavBar(index: index, onChangedTab: onChangedTab,),
        body: pages[index],
      ),
    );
  }
  void onChangedTab(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }
}