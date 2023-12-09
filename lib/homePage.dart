import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      appBar: AppBar(
        title: Text('Item Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
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
                style: TextStyle(color: Colors.white),
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
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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