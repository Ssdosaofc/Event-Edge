import 'package:event_edge/pages/Home.dart';
import 'package:event_edge/pages/forgotPassword.dart';
import 'package:event_edge/pages/login.dart';
import 'package:event_edge/pages/register.dart';
import 'package:event_edge/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          '/sign_up':(context)=> Signup(),
          '/forgot-password': (context) =>  ForgotPassword(),
          '/home':(context)=> Home(),
          // '/add_event':(context)=>AddEvent(),

        },
        builder: (context, child) {
          return Stack(
            children: [
              child ?? const SizedBox.shrink(),
              const AnimatedSnackbar(),
            ],
          );
        },
      ),
    );
  }
}
