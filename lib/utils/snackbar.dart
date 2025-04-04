import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/snackbarData.dart';

final snackbarProvider = StateProvider<SnackbarData?>((ref) => null);

class AnimatedSnackbar extends ConsumerWidget {
  const AnimatedSnackbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snackbarData = ref.watch(snackbarProvider);
    if (snackbarData == null) return const SizedBox.shrink();

    Future.delayed(const Duration(seconds: 2), () {
      ref.read(snackbarProvider.notifier).state = null;
    });

    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedSlide(
        offset: const Offset(0, 0),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Material(
            borderRadius: BorderRadius.circular(12),
            elevation: 6,
            color: snackbarData.backgroundColor ?? Colors.black87,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: snackbarData.backgroundColor ?? Colors.black87,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (snackbarData.icon != null) ...[
                    Icon(snackbarData.icon, color: Colors.white, size: 24),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      snackbarData.message,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  if (snackbarData.actionLabel != null)
                    TextButton(
                      onPressed: snackbarData.onAction,
                      child: Text(snackbarData.actionLabel!, style: const TextStyle(color: Colors.white)),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}