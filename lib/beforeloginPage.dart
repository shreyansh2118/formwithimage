import 'package:flutter/material.dart';
import 'package:hostel/adminSide/adminLogin.dart';
import 'package:hostel/login/loginPage.dart';

import 'namePage.dart';
class beforeLogin extends StatefulWidget {
  const beforeLogin({super.key});

  @override
  State<beforeLogin> createState() => _beforeLoginState();
}

class _beforeLoginState extends State<beforeLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    appBar: AppBar(
      title: const Text('Select author'),

    ),
    body: Center(
      child: Column(
        children: [
          SizedBox(height: 160,),
          Container(
            child: ElevatedButton( onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => adminLogin()));
              // admin ko add krna hai
            },child: Text("Admin"),),
          ),
          SizedBox(height: 50,),
          Container(
            child: ElevatedButton( onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => loginFirst()));
            },child: Text("Student"),),
          )
        ],
      ),
    ),
    );
  }
}
