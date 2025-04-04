import 'package:flutter/material.dart';

class SnackbarData {
  final String message;
  final Color? backgroundColor;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  SnackbarData({
    required this.message,
    this.backgroundColor,
    this.icon,
    this.actionLabel,
    this.onAction,
  });
}