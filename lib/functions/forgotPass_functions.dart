import 'package:event_edge/utils/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/snackbarData.dart';
import '../provider/snackbar_provider.dart';


Future<void> sentEmail(BuildContext context, WidgetRef ref, String email) async {
  final url = Uri.parse(Utils.forgotUrl);

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      ref.read(snackbarProvider.notifier).state = SnackbarData(
        message: "Reset link sent! Check your email.",
        backgroundColor: Colors.green,
        icon: Icons.check_circle_outline,
      );
    } else {
      ref.read(snackbarProvider.notifier).state = SnackbarData(
        message: data["message"] ?? "Something went wrong",
        backgroundColor: Colors.red,
        icon: Icons.error_outline,
      );
    }
  } catch (e) {
    ref.read(snackbarProvider.notifier).state = SnackbarData(
      message: "Error: $e",
      backgroundColor: Colors.red,
      icon: Icons.error_outline,
    );
  }
}
