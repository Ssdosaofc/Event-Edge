import 'dart:convert';
import 'dart:io';

import 'package:event_edge/utils/api.dart';
import 'package:event_edge/widgets/customInputField.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();

}
class _ProfileState extends State<Profile> {
  final TextEditingController nameController=TextEditingController();
  final TextEditingController emailController=TextEditingController();
  File? filePath;
  final ImagePicker picker = ImagePicker();

  void initState() {
    super.initState();
    loadUserData();
    fetchProfile();
    filePath=null;
  }

  Future<void> saveProfile() async {
    final uri = Uri.parse(Utils.saveProfileUrl);
    String base64Image = '';

    if (filePath != null) {
      List<int> imageBytes = await filePath!.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': nameController.text,
        'email': emailController.text,
        'profileImage': base64Image,
        'bgImage':base64Image
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
          content: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.green
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline,),
                Text(" Profile Saved"),
              ],
            ),
          )));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', nameController.text);
      await prefs.setString('email', emailController.text);
      await prefs.setString('profileImage', base64Image);
      await prefs.setString('bgImage', base64Image);
    } else {
      print('Failed to save');
    }
  }

  Future<void> fetchProfile() async {
    final uri = Uri.parse(Utils.fetchProfileUrl+"${emailController.text}");

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = data['user'];

      setState(() {
        nameController.text = user['name'];
        emailController.text = user['email'];

        if (user['profileImage'] != null) {
          filePath = File.fromRawPath(base64Decode(user['profileImage']));
        }
        if(user['bgImage'] != null){
          filePath = File.fromRawPath(base64Decode(user['bgImage']));
        }
      });
    } else {
      print("Error fetching profile");
    }
  }


  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    String? email = prefs.getString('email');

    setState(() {
      nameController.text = name ?? '';
      emailController.text = email ?? '';
    });
  }

  pickImage() async{
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if(image == null) return;
    var imgMap = File(image.path);

    setState(() {
      filePath = imgMap;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: () {
                  pickImage();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (filePath== null)?Image(image: AssetImage('assets/images/blank.png'),height: 216,width: 286,)
                        :Image.file(filePath!,height: 216,width: 286),
                  ],
                ),
              ),

              Positioned(
                bottom: -40,
                left: 10,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: GestureDetector(
                    onTap: (){
                      pickImage();
                    },
                    child: CircleAvatar(
                      radius: 46,
                      backgroundImage: AssetImage("assets/images/people.png"),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 60),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            child: CustomInputField(
                controller: nameController,
                hintText: "Name",
                icon: Icons.person
            ),
          ),
          const SizedBox(height: 10),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            child: CustomInputField(
                controller: emailController,
                hintText: "Email",
                icon: Icons.mail
            ),
          ),
          SizedBox(height: 50,),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed:(){
                saveProfile();
              },
              child: const Text(
                "Save changes",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
