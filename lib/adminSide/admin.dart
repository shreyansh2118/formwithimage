import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

import '../login/authFile.dart';
import 'adminLogin.dart';
class admin extends StatefulWidget {
  var name;

  var desc;

  admin ({Key? key, required this.name, required this.desc}) : super(key: key);

  @override
  State<admin > createState() => _adminState();
}

class _adminState extends State<admin > {
  FirebaseStorage storage = FirebaseStorage.instance;

  // Select and image from the gallery or take a picture with the camera
  // Then upload to Firebase Storage
  Future<void> _upload(String inputSource) async {
    final picker = ImagePicker();
    XFile? pickedImage;
    try {
      pickedImage = await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920);

      final String fileName = path.basename(pickedImage!.path);
      File imageFile = File(pickedImage.path);

      try {
        // Uploading the selected image with some custom meta data
        await storage.ref(fileName).putFile(
            imageFile,
            SettableMetadata(customMetadata: {
              'uploaded_by': 'uploaded by ${widget.name} ',
              'description': ' ${widget.desc} '
            }));

        // Refresh the UI
        setState(() {});
      } on FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }
  // Color _cardColor = Colors.yellow;
  // void _changeColor() {
  //   setState(() {
  //     // Toggle between two colors when the card is clicked
  //     _cardColor = _cardColor == Colors.yellow ? Colors.greenAccent : Colors.red;
  //   });
  // }
  // Retriew the uploaded images
  // This function is called when the app launches for the first time or when an image is uploaded or deleted
  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage.ref().list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
        "description":
        fileMeta.customMetadata?['description'] ?? 'No description'
      });
    });

    return files;
  }

  // Delete the selected image
  // This function is called when a trash icon is pressed
  Future<void> _delete(String ref) async {
    await storage.ref(ref).delete();
    // Rebuild the UI
    setState(() {});
  }
  // int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome Admin'),
        actions: [
          ElevatedButton(onPressed: (){
          emailAuth().signOut()
              .then((result) {
            if (result == null) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => adminLogin()));
            } else {
              // Scaffold.of(context).showSnackBar(SnackBar(
              //   content: Text(
              //     result,
              //     style: TextStyle(fontSize: 16),
              //   ),
              // ));
            }
          });
        }, child: Text("LogOut")),],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Container(
              child: Text("All Posts",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 24),),
            ),SizedBox(height: 20,),
            Row(
              children: [
                Container(
                  height:20,
                  width: 20,
                  decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(100)
                    //more than 50% of width makes circle
                  ),
                ),
                SizedBox(width: 10,),
                Container(
                  child: Text("In review",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 24),),
                ),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     ElevatedButton.icon(
            //         onPressed: () => _upload('camera'),
            //         icon: const Icon(Icons.camera),
            //         label: const Text('camera')),
            //     ElevatedButton.icon(
            //         onPressed: () => _upload('gallery'),
            //         icon: const Icon(Icons.library_add),
            //         label: const Text('Gallery')),
            //   ],
            // ),
            Expanded(
              child: FutureBuilder(
                future: _loadImages(),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> image =
                        snapshot.data![index];

                        return GestureDetector(
                          child: Card(
                            color: Colors.orangeAccent,
                            // color: selectedIndex == index? Colors.orangeAccent : null,
                            margin: new EdgeInsets.symmetric(vertical: 20.0),
                            child: ListTile(

                              dense: false,
                              leading: Image.network(image['url']),
                              title: Text(image['uploaded_by']),
                              subtitle: Text(image['description']),
                              trailing: IconButton(
                                onPressed: () => _delete(image['path']),

                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          // onTap: () {
                          //   setState(() {
                          //     selectedIndex = index;
                          //   });
                          // },
                        );

                      },
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
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