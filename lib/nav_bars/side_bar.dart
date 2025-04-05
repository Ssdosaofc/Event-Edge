import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';

import '../models/user.dart';
import '../pages/login.dart';
import '../pages/side_bar_pages/orders.dart';
import '../pages/side_bar_pages/tickets.dart';
import '../provider/themeNotifier_provider.dart';
import '../utils/constants.dart';

class Sidebar extends ConsumerWidget {
  final List<User> sampleUsers = [
    User(
      age: 25,
      state: 'Maharashtra',
      country: 'India',
      pincode: 400001,
      buyTime: '2025-04-05T10:00:00',
      category: 'Concert',
      amount: 500,
      payMethod: 'UPI',
      eventID: 1,
      prevHistory: 2,
    ),
    User(
      age: 30,
      state: 'Karnataka',
      country: 'India',
      pincode: 560001,
      buyTime: '2025-04-05T11:00:00',
      category: 'Conference',
      amount: 800,
      payMethod: 'Credit Card',
      eventID: 2,
      prevHistory: 1,
    ),
    User(
      age: 22,
      state: 'Delhi',
      country: 'India',
      pincode: 110001,
      buyTime: '2025-04-05T12:00:00',
      category: 'Workshop',
      amount: 300,
      payMethod: 'Debit Card',
      eventID: 3,
      prevHistory: 0,
    ),
    User(
      age: 27,
      state: 'Tamil Nadu',
      country: 'India',
      pincode: 600001,
      buyTime: '2025-04-05T13:00:00',
      category: 'Concert',
      amount: 450,
      payMethod: 'Wallet',
      eventID: 4,
      prevHistory: 3,
    ),
    User(
      age: 25,
      state: 'MH',
      country: 'India',
      pincode: 400001,
      buyTime: '10:00',
      category: 'Concert',
      amount: 500,
      payMethod: 'UPI',
      eventID: 1,
      prevHistory: 2,
    ),
    User(
      age: 30,
      state: 'DL',
      country: 'India',
      pincode: 110001,
      buyTime: '12:00',
      category: 'Theatre',
      amount: 700,
      payMethod: 'Credit Card',
      eventID: 2,
      prevHistory: 1,
    ),
    User(
      age: 22,
      state: 'KA',
      country: 'India',
      pincode: 560001,
      buyTime: '15:00',
      category: 'Stand-up',
      amount: 300,
      payMethod: 'Wallet',
      eventID: 3,
      prevHistory: 0,
    ),
    User(
      age: 35,
      state: 'West Bengal',
      country: 'India',
      pincode: 700001,
      buyTime: '2025-04-05T14:00:00',
      category: 'Conference',
      amount: 600,
      payMethod: 'Others',
      eventID: 5,
      prevHistory: 4,
    ),
  ];

   Sidebar({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  void logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
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

      items: [
        SidebarXItem(
          icon: Icons.home,
          label: 'Home',
        ),
        SidebarXItem(
          icon: CupertinoIcons.tickets,
          label: 'Tickets',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Tickets()));
          },
        ),
        SidebarXItem(
          icon: Icons.list_alt,
          label: 'Orders',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Orders(users: sampleUsers,)));
          },
        ),
        SidebarXItem(
          icon: Icons.power_settings_new,
          label: 'Logout',
          onTap: () {
            logout(context);
          },
        ),
        // SidebarXItem(
        //   icon: Icons.dark_mode,
        //   label: 'Dark Mode',
        //   onTap: () {
        //     ref.read(themeNotifierProvider.notifier).toggleTheme();
        //   },
        // ),
      ],
        footerBuilder: (context, extended) {
          return Column(
            children: [
              divider,
              InkWell(
                onTap: () {
                  ref.read(themeNotifierProvider.notifier).toggleTheme();
                },
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment:
                    extended ? MainAxisAlignment.start : MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.dark_mode, color: Colors.black),
                      if (extended)
                        const SizedBox(width: 16),
                      if (extended)
                        Text(
                          'Dark Mode',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

    );
  }
}

final divider = Divider(color: gray.withOpacity(0.3), height: 1);



