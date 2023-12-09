import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'add item.dart';

class ItemDetails {
  String itemName;
  DateTime installmentDate;
  DateTime maintenanceDate;
  File? image;
  String contractorContact;

  ItemDetails({
    required this.itemName,
    required this.installmentDate,
    required this.maintenanceDate,
    this.image,
    required this.contractorContact,
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Item Details',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DisplayItemScreen(),
    );
  }
}

class DisplayItemScreen extends StatefulWidget {
  @override
  _DisplayItemScreenState createState() => _DisplayItemScreenState();
}

class _DisplayItemScreenState extends State<DisplayItemScreen> {
  List<ItemDetails> _itemList = [];

  int _calculateMonthsDifference(DateTime startDate, DateTime endDate) {
    final difference = endDate.difference(startDate).inDays;
    return (difference / 30).ceil(); // Rounded up to the nearest month
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Item Details'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 30,),
            Center(
              child: Container(
                child: Text("Your items",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 32,color: Colors.black),),

              ),
            ),
            SizedBox(height: 30,),
            TextButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddItemScreen()),
                );
                if (result != null) {
                  setState(() {
                    _itemList.add(result as ItemDetails);
                  });
                }
              },
              child: Text(
                'Add Item',
                style: TextStyle(color: Colors.black,),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            if (_itemList.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _itemList.length,
                  itemBuilder: (context, index) {
                    final maintenanceDifference = _calculateMonthsDifference(
                      _itemList[index].maintenanceDate,
                      DateTime.now(),
                    );
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_itemList[index].image != null)
                          Container(
                            height: 230,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: FileImage(_itemList[index].image!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                        Row(
                          children: [
                            Text(
                              '${_itemList[index].itemName}: ',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              ' $maintenanceDifference months',
                            ),
                          ],
                        ),
                        Divider(),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

