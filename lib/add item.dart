import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'itemscreen.dart';
class AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  ItemDetails _itemDetails = ItemDetails(
    itemName: '',
    installmentDate: DateTime.now(),
    maintenanceDate: DateTime.now(),
    contractorContact: '',
  );
  final picker = ImagePicker();
  final CollectionReference itemsCollection =
  FirebaseFirestore.instance.collection('items');

  bool _isButtonDisabled() {
    return _itemDetails.itemName.isEmpty ||
        _itemDetails.maintenanceDate == null ||
        _itemDetails.image == null;
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _itemDetails.image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  void _submitForm() async {
    if (!_isButtonDisabled() &&
        _itemDetails.contractorContact.isNotEmpty) {
      try {
        await itemsCollection.add({
          'itemName': _itemDetails.itemName,
          'expectedMaintenanceDate': _itemDetails.maintenanceDate,
          'installmentDate': _itemDetails.installmentDate,
          'contractorContact': _itemDetails.contractorContact,
        });

        Navigator.pop(context, _itemDetails);
      } catch (e) {
        print('Error adding item: $e');
      }
    } else {
      print('Please enter details.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Add Item'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 30,),
              Center(
                child: Container(
                  child: Text("Add item",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 32),),
                ),
              ),
              SizedBox(height: 30,),
              TextFormField(
                decoration: InputDecoration(labelText: 'Item Name'),
                onChanged: (value) {
                  setState(() {
                    _itemDetails.itemName = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration:
                InputDecoration(labelText: 'Installment Date (YYYY-MM-DD)'),
                onChanged: (value) {
                  setState(() {
                    _itemDetails.installmentDate = DateTime.parse(value);
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Expected Maintenance Date (YYYY-MM-DD)'),
                onChanged: (value) {
                  setState(() {
                    _itemDetails.maintenanceDate = DateTime.parse(value);
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contractor Contact'),
                onChanged: (value) {
                  setState(() {
                    _itemDetails.contractorContact = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () => _getImage(ImageSource.gallery),
                    icon: Icon(Icons.image),
                    label: Text('Choose Image'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _getImage(ImageSource.camera),
                    icon: Icon(Icons.camera_alt),
                    label: Text('Take Photo'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isButtonDisabled() ? null : _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
