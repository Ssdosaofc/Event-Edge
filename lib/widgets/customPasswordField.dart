import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/password_visiblity_provider.dart';

class CustomPasswordField extends ConsumerWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;

  const CustomPasswordField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context , WidgetRef ref) {

    bool isVisible = ref.watch(password_visibility_provider);
    Icon visibilityIcon = Icon(Icons.visibility_off);
    if(isVisible){
      visibilityIcon = Icon(Icons.visibility);
    }

    return Padding(padding: EdgeInsets.symmetric(vertical: 6),
      child: TextField(
          controller: controller,
          obscureText: !isVisible,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: Colors.black54),
            suffixIcon: InkWell(
              child: visibilityIcon,
              onTap: (){
                ref.read(password_visibility_provider.notifier).state = !isVisible;
              },
            ),
            filled: true,
            labelStyle: TextStyle(color: Colors.black),
            fillColor: Colors.black.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          )),);
  }
}