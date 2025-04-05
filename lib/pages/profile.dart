import 'dart:io';

import 'package:event_edge/widgets/customInputField.dart';
import 'package:flutter/material.dart';
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
    filePath=null;
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
                bottom: -30,
                left: 10,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 46,
                    backgroundImage: AssetImage("assets/images/people.png"),
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
              onPressed:(){},
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
