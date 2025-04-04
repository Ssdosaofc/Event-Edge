import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int index;
  final ValueChanged<int> onChangedTab;
  const BottomNavBar({super.key,required this.index, required this.onChangedTab,});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      color: Color(0xFFFE8C43),
      notchMargin: 6,
      shape: const CircularNotchedRectangle(),
      child: Row(
        // mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildTabItem(
            index: 0,
            tooltip: 'Dashboard',
            icon: Icons.dashboard_outlined
          ),
          buildTabItem(
            index: 1,
            tooltip: 'Recommendations',
            icon: Icons.recommend_outlined
          ),
          SizedBox(width: 50,),
          buildTabItem(
            index: 2,
            tooltip: 'History',
            icon: Icons.history
          ),
          buildTabItem(
            index: 3,
            tooltip: 'Profile',
            icon: Icons.person
          ),
        ],
      ),
    );
  }

  Widget buildTabItem({required int index, required IconData icon, required String tooltip}){
    final isSelected = index == widget.index;
    return IconButton(
        onPressed: ()=>widget.onChangedTab(index),
        tooltip: tooltip,
        icon: Icon(icon, color: isSelected?Colors.grey[900]:Colors.white)
    );
  }

}
