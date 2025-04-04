import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/gradient.dart';
import '../widgets/customInputField.dart';
import '../widgets/text.dart';
import 'login.dart';

class ForgotPassword extends ConsumerWidget {
  ForgotPassword({super.key});

  final TextEditingController emailController=TextEditingController();


  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 50,),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: orangeGradient
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20,top: 10),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                  },
                  child: Icon(Icons.arrow_back_ios,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 60,top: 5),
                child: Row(
                  children: [
                    MyText(
                        text: "FORGOT PASSWORD",
                        fontColor:Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        decoration:TextDecoration.none
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 50,left: 30,right: 30),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock,
                            size: 100,
                            color: Color(0xfffb9726),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      CustomInputField(
                        controller: emailController,
                        hintText: "Email",
                        icon: Icons.email,
                        isEmail: true,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      _buildButton(context,ref,emailController.text.trim()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildButton(BuildContext context,WidgetRef ref, String email) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8))),
      onPressed: () {
        // sentEmail(context, ref, email);
      },
      child: Text("Sent", style: TextStyle(color: Colors.white,fontSize: 16)),
    ),
  );
}