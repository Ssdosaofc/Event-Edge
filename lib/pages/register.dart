import 'dart:convert';
import 'package:event_edge/widgets/customPasswordField.dart';
import 'package:event_edge/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/api.dart';
import '../utils/gradient.dart';
import '../widgets/customInputField.dart';
import 'Home.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController    = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    final String name = usernameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          content: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.red,
            ),
            child: Row(
              children: const [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 5),
                Text("All fields are required", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          content: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.red,
            ),
            child: Row(
              children: const [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 5),
                Text("Passwords don't match", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
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

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
            content: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.green,
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.white),
                  const SizedBox(width: 5),
                  Text(responseData['Success'] ?? "Registered successfully",
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
            content: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.red,
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 5),
                  Text(responseData['error'] ?? "Registration failed",
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          content: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.red,
            ),
            child: Row(
              children: const [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 5),
                Text("Something went wrong. Please try again later",
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 30),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(gradient: orangeGradient),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: MyText(
                  text: "Register User",
                  fontColor: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MyText(
                        text: "Name",
                        fontColor: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                      const SizedBox(height: 5),
                      CustomInputField(
                        controller: usernameController,
                        hintText: "Name",
                        icon: Icons.person,
                        isEmail: false,
                      ),
                      const SizedBox(height: 10),
                      const MyText(
                        text: "Email",
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
                      const SizedBox(height: 10),
                      const MyText(
                        text: "Password",
                        fontColor: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                      const SizedBox(height: 5),
                      CustomPasswordField(
                        controller: passwordController,
                        hintText: "Password",
                        icon: Icons.lock,
                      ),
                      const SizedBox(height: 10),
                      const MyText(
                        text: "Confirm Password",
                        fontColor: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                      const SizedBox(height: 5),
                      CustomPasswordField(
                        controller: confirmPasswordController,
                        hintText: "Password",
                        icon: Icons.lock,
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: registerUser,
                          child: const Text(
                            "Register",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 10),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
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
                                    decoration: TextDecoration.underline,
                                  ),
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
