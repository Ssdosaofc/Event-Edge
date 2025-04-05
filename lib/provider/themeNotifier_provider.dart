import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../functions/theme_notifier.dart';

final themeNotifierProvider =
StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) => ThemeNotifier());