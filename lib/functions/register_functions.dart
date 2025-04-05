
import 'dart:convert';

import 'package:event_edge/pages/login.dart';
import 'package:event_edge/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/snackbarData.dart';
import '../provider/snackbar_provider.dart';


Future<void> registerUser(BuildContext context, WidgetRef ref,nameController,emailController,passwordController,confirmPasswordController) async {
  final String name = nameController.text.trim();
  final String email = emailController.text.trim();
  final String password = passwordController.text.trim();
  final String confirmPassword = confirmPasswordController.text.trim();

  if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
    ref.read(snackbarProvider.notifier).state = SnackbarData(
      message: "All fields are required",
      backgroundColor: Colors.red,
      icon: Icons.check_circle_outline,
    );
    // Fluttertoast.showToast(msg:"All fields are required");
    return;
  }

  if (password != confirmPassword) {
    ref.read(snackbarProvider.notifier).state = SnackbarData(
      message: "Password don't match",
      backgroundColor: Colors.red,
      icon: Icons.check_circle_outline,
    );
    return;
  }

  final url = Uri.parse(Utils.registrationUrl);

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    print("Sending data: $name, $email, $password");


    final responseData = jsonDecode(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      ref.read(snackbarProvider.notifier).state = SnackbarData(
        message: responseData['Success'] ?? "Registration Successful",
        backgroundColor: Colors.green,
        icon: Icons.check_circle_outline,
      );
      // Fluttertoast.showToast(msg: responseData['Success'] ?? 'Registration successful.');
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      ref.read(snackbarProvider.notifier).state = SnackbarData(
        message:responseData['error'] ?? "Registration failed",
        backgroundColor: Colors.red,
        icon: Icons.error_outline,
      );
      // Fluttertoast.showToast(msg: responseData['error'] ?? 'Registration failed.');
    }
  } catch (e) {
    print("Error: $e");
    ref.read(snackbarProvider.notifier).state = SnackbarData(
      message: "Something went wrong.Please try again",
      backgroundColor: Colors.red,
      icon: Icons.error_outline,
    );
  }
}