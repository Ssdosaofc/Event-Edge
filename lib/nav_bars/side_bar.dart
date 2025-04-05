import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sidebarx/sidebarx.dart';

import '../provider/themeNotifier_provider.dart';
import '../utils/constants.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(20),
        ),
        // hoverColor: Colors.black,
        textStyle: TextStyle(color: Colors.grey[900]!.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        hoverTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),

        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: gray.withOpacity(0.37),
          ),
          gradient: LinearGradient(
            colors: [strong,orange],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.grey[900]!.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: white,
        ),
      ),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return Container(
          height: 150,
          padding: const EdgeInsets.all(16.0),
          child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: gray.withOpacity(0.37),
                ),
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.person,size: extended?70:20,),
                ),
              )
          ),
        );
      },
      footerBuilder: (context, extended) {
        return Consumer(
          builder: (context, ref, _) {
            final themeMode = ref.watch(themeNotifierProvider);
            final isDarkMode = themeMode == ThemeMode.dark;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.dark_mode, color: Colors.grey[700], size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Dark Mode",
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                  ),
                  Switch(
                    value: isDarkMode,
                    onChanged: (val) {
                      ref.read(themeNotifierProvider.notifier).toggleTheme();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },


      items: [
        SidebarXItem(
          icon: Icons.home,
          label: 'Home',
        ),
        SidebarXItem(
          icon: CupertinoIcons.tickets,
          label: 'Tickets',
          onTap: () {

            // Navigator.push(context, MaterialPageRoute(builder: (context) => const Tickets()));
          },
        ),
        SidebarXItem(
          icon: Icons.list_alt,
          label: 'Orders',
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const Orders()));
          },
        ),
      ],
    );
  }
}

final divider = Divider(color: gray.withOpacity(0.3), height: 1);



