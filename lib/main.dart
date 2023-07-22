import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hostel/login/loginPage.dart';
import 'package:hostel/namePage.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

import 'beforeloginPage.dart';
import 'homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize a new Firebase App instance
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Kindacode.com',
      theme: ThemeData(primarySwatch: Colors.green),
      home: beforeLogin(),
    );
  }
}
