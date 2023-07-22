// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:hostel/mainPage.dart';
// import 'package:hostel/profile.dart';
// class valid extends StatefulWidget {
//   const valid({Key? key}) : super(key: key);
//   @override
//   State<valid> createState() => _validState();
// }
// class _validState extends State<valid> {
//   final myController = TextEditingController();
//   @override
//   void dispose() {
//     // Clean up the controller when the widget is disposed.
//     myController.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 50,
//           ),
//           TextField(
//             controller: myController,
//             decoration: InputDecoration(labelText: 'Enter Name'),
//           ),
//           // Step 1 <-- SEE HERE
//           ElevatedButton(
//             onPressed: () {
//               // Step 3 <-- SEE HERE
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   // builder: (context) => profile(title: myController.text),
//                   builder: (context) => mainPage(),
//                 ),
//               );
//             },
//             child: const Text(
//               'Next',
//               style: TextStyle(fontSize: 24),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
