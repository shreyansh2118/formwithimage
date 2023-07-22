import 'package:flutter/material.dart';
import 'package:hostel/login/loginPage.dart';
import 'package:hostel/mainPage.dart';

import 'beforeloginPage.dart';
import 'login/authFile.dart';

class profile extends StatefulWidget {
  // profile({Key? key, required this.title}) : super(key: key);
  profile({Key? key}) : super(key: key);
  // final String title;
  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text( '${widget.title}',),
            ElevatedButton(onPressed: (){
              emailAuth().signOut()
                  .then((result) {
                if (result == null) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => beforeLogin()));
                }
                else {
                  // Scaffold.of(context).showSnackBar(SnackBar(
                  //   content: Text(
                  //     result,
                  //     style: TextStyle(fontSize: 16),
                  //   ),
                  // ));
                }
              });
            }, child: Text("LogOut")),
          ],
        ),
      )

    );
  }
}
