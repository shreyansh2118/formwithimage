import 'package:flutter/material.dart';
import 'package:hostel/profile.dart';

import 'dashboard.dart';
import 'namePage.dart';
class mainPage extends StatefulWidget {
  @override
  _mainPageState createState() => _mainPageState();
}
class _mainPageState extends State<mainPage > {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    dash(name: name, desc:desc,),
  // Text("dddd"),
  // Text("dd"),
    // dash(name: name, desc:desc,),
    namePage(),
    // profile(title: title),
    profile(),
  ];

  static var name;

  static var desc;

  static var title;





  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,

            ),
            label: 'HOME',
            // activeIcon: Icon(
            //   Icons.home,
            //   // color: kGoodPurple,
            // ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              // color: kGoodLightGray,
            ),
            label: 'HOME',
            activeIcon: Icon(
              Icons.add,
              // color: kGoodPurple,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              // color: kGoodLightGray,
            ),
            label: 'HOME',
            // activeIcon: Icon(
            //   Icons.home,
            //   // color: kGoodPurple,
            // ),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }

}

