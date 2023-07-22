
import 'package:flutter/material.dart';
import 'package:hostel/beforeloginPage.dart';
import 'package:hostel/homePage.dart';

// import '../../authfile/emailAuth.dart';
import '../mainPage.dart';
import '../namePage.dart';
import '../valid.dart';
import 'authFile.dart';

class loginFirst extends StatefulWidget {
  const loginFirst({super.key});

  @override
  State<loginFirst> createState() => _loginFirstState();
}

class _loginFirstState extends State<loginFirst> {
  bool islogin = false;
  String email = " ";
  String password = " ";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: Image.asset("asset/login.jpeg"),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60, left: 16),
                    child: !islogin
                        ? Text(
                      "Login or Signup",
                      style: TextStyle(fontSize: 22),
                    )
                        : Container(),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: TextField(
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter Email",
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(width: 3, color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: TextField(
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter Password",
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(width: 3, color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: islogin? ElevatedButton(
                        onPressed: () {
                          // islogin?signup(email,password): signin(email,password);
                          // Get username and password from the user.Pass the data to

                          emailAuth()
                              .signIn(email: email, password: password)
                              .then((result) {
                            if (result == null) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => valid()));
                            } else {
                              // Scaffold.of(context).showSnackBar(SnackBar(
                              //   content: Text(
                              //     result,
                              //     style: TextStyle(fontSize: 16),
                              //   ),
                              // ));
                            }
                          });
                        },
                        child: Text("logIn"))
                        : ElevatedButton(
                        onPressed: () {
                          // islogin?signup(email,password): signin(email,password);
                          // Get username and password from the user.Pass the data to

                          emailAuth()
                              .signUp(email: email, password: password)
                              .then((result) {
                            if (result == null) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => valid()));
                            } else {
                              // Scaffold.of(context).showSnackBar(SnackBar(
                              //   content: Text(
                              //     result,
                              //     style: TextStyle(fontSize: 16),
                              //   ),
                              // ));
                            }
                          });
                        },
                        child: Text("signUp"))),

                TextButton(
                    onPressed: () {
                      setState(() {
                        islogin = !islogin;
                      });
                    },
                    child: islogin
                        ? Text("don't have account? Signup")
                        : Text('Already Signed up? Login'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
