import 'package:event_edge/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/gradient.dart';
import '../widgets/customInputField.dart';
import '../widgets/customPasswordField.dart';
import '../widgets/text.dart';
import 'forgotPassword.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 30),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: orangeGradient
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: MyText(
                    text: "Hello\nSignIn!",
                    fontColor: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  )
              ),
              SizedBox(height: 40),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 50, left: 30, right: 30),
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: "Email",
                        // fontColor: Color(0xfffb9726),
                        fontColor: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,

                      ),
                      const SizedBox(height: 5),
                      CustomInputField(
                        controller: emailController,
                        hintText: "Email",
                        icon: Icons.email,
                        isEmail: true,
                      ),

                      SizedBox(height: 15),
                      MyText(
                        text: "Password",
                        // fontColor: Color(0xfffb9726),
                        fontColor: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                      const SizedBox(height: 5),
                      CustomPasswordField(
                          controller: passwordController,
                          hintText: "Password",
                          icon: Icons.lock),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                // color: Color.fromARGB(255, 184, 102, 11),
                                color: Colors.black45,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 70),
                      _buildButton(context, ref),
                      SizedBox(height: 150,),
                      // SizedBox(height: MediaQuery.of(context).size.height / 6),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     MyText(
                      //         text:"Don't have an account?",
                      //         fontColor: Colors.black45,
                      //         fontSize: 18,
                      //         fontWeight: FontWeight.w500,
                      //       decoration: TextDecoration.none,
                      //     ),
                      //     SizedBox(width: 10),
                      //     GestureDetector(
                      //         onTap: () {
                      //           Navigator.push(context, MaterialPageRoute(builder: (context)=>Signup()));
                      //         },
                      //         child: MyText(text: "SIGN UP",
                      //             fontColor:Color.fromARGB(255, 184, 102, 11),
                      //             fontSize: 20,
                      //             fontWeight: FontWeight.bold,
                      //             decoration: TextDecoration.underline,
                      //         )
                      //     ),
                      //   ],
                      // ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Signup()),
                            );
                          },
                          child: const Text.rich(
                            TextSpan(
                              text: "Don't have an account? ",
                              children: [
                                TextSpan(
                                  text: "Sign Up",
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
Widget _buildButton(BuildContext context,WidgetRef ref) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8))),
      onPressed: () {
        Navigator.pushNamed(context, '/home');
      },
      child: Text("Login", style: TextStyle(color: Colors.white,fontSize: 16)),
    ),
  );
}