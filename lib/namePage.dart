import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

import 'homePage.dart';
// import 'mainHomePage.dart';

class namePage extends StatefulWidget {
  var name;

   namePage({super.key});

  @override
  State<namePage> createState() => _namePageState();
}

class _namePageState extends State<namePage> {


  TextEditingController _name = TextEditingController();
  TextEditingController _desc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(automaticallyImplyLeading: false,
        // elevation: 0,
        // backgroundColor: Colors.white70,
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(

          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 15,),
                  Container(
                    child: Container(
                      child: Text(
                        "Just A step away !",
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: TextField(
                      controller: _name,
                      decoration: InputDecoration(
                        hintText: "Full Name ",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.black12),
                          // borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 30,
                  ),
                  // SizedBox(
                  //   height: 200,
                  //   child: TextField(
                  //     minLines: 1,
                  //     maxLines: 10,
                  //     controller: _desc,
                  //     decoration: InputDecoration(
                  //
                  //       hintText: "Enter description with room and roll no... ",
                  //       enabledBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(width: 3, color: Colors.black12),
                  //         // borderRadius: BorderRadius.circular(50.0),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      border: Border.all(width: 3,color: Colors.black12)
                    ),
                    child: TextField(
                      minLines: 1,
                      maxLines: 10,
                      // textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter description with room and roll no... ",
                      ),
                    ),
                  ),
                  // SizedBox(height: MediaQuery.of(context).size.height/1.9),
                  SizedBox(height: 60,),
                  Container(

                    child: ElevatedButton(
                      child: Text("next"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage(name: _name.text,desc: _desc.text)),
                        );
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.purple),
                          // padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18))),
                    ),
                  )
                ],
              ),
            ],
          ),

        ),

      ),


    );
  }
}
