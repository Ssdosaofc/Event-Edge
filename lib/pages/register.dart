import 'dart:convert';

import 'package:event_edge/functions/register_functions.dart';
import 'package:event_edge/widgets/customPasswordField.dart';
import 'package:event_edge/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/gradient.dart';
import '../utils/snackbar.dart';
import '../widgets/customInputField.dart';
import 'login.dart';


final usernameControllerProvider =Provider((ref)=> TextEditingController());
final emailControllerProvider=Provider((ref)=>TextEditingController());
final passwordControllerProvider=Provider((ref)=> TextEditingController());
final confirmPasswordControllerProvider=Provider((ref)=> TextEditingController());

class Signup extends ConsumerWidget{
  Signup({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController=ref.watch(usernameControllerProvider);
    final emailController=ref.watch(emailControllerProvider);
    final passwordController=ref.watch(passwordControllerProvider);
    final confirmPasswordController=ref.watch(confirmPasswordControllerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 30,),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient:orangeGradient
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Padding(
          padding: const EdgeInsets.only(left: 30.0),
            child:MyText(
                text: "Register User",
                fontColor: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none
            ) ,
          ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 20,left: 30,right: 30),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: "Name",
                          fontColor: Colors.black54,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none),
                        SizedBox(height: 5,),
                        CustomInputField(
                          controller: usernameController,
                          hintText: "Name",
                          icon: Icons.person,
                          isEmail: false,
                        ),
                        SizedBox(height: 10,),
                        MyText(
                          text: "Email",
                          fontColor: Colors.black54,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                        ),
                        SizedBox(height: 5,),
                        CustomInputField(
                          controller: emailController,
                          hintText: "Email",
                          icon: Icons.email,
                          isEmail: true,
                        ),
                        SizedBox(height: 10,),
                        MyText(
                          text: "Password",
                          fontColor: Colors.black54,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                        SizedBox(height: 5,),
                        CustomPasswordField(
                            controller: passwordController,
                            hintText: "Password",
                            icon: Icons.lock),
                        SizedBox(height: 10,),
                        MyText(
                          text: "Confirm Password",
                          fontColor: Colors.black54,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                        SizedBox(height: 5,),
                        CustomPasswordField(
                            controller: confirmPasswordController,
                            hintText: "Password",
                            icon: Icons.lock),
                        const SizedBox(
                          height: 40,
                        ),
                        _buildButton(context, ref,usernameController,emailController,passwordController,confirmPasswordController),
                        SizedBox(height: MediaQuery.of(context).size.height/10),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                            },
                            child: const Text.rich(
                              TextSpan(
                                text: "Already have an account? ",
                                children: [
                                  TextSpan(
                                    text: "Login",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        decoration: TextDecoration.underline),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]
                    ),
              )
              ),
            ]
          ),
        ),
      ),
    );
  }
}

Widget _buildButton(BuildContext context,WidgetRef ref,username,email,password,confirmPassword) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8))),
      onPressed: () {
        registerUser(context,ref,username,email,password,confirmPassword);
      },
      child: Text("Register", style: TextStyle(color: Colors.white,fontSize: 16)),
    ),
  );
}
