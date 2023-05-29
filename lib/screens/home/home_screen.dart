import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../patients/patient_screen.dart';
import '/screens/dashboard/dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _cIndex = 0;

  void _incrementTab(index) {
    setState(() {
      _cIndex = index;
    });
  }

  final List<Widget> _children = [
    const DashboardScreen(),
    Container(),
    Container()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: _children[_cIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: GNav(
                onTabChange: (index) {
                  _incrementTab(index);
                },
                mainAxisAlignment: MainAxisAlignment.start,
                backgroundColor: Colors.black,
                color: Colors.white,
                activeColor: Colors.teal,
                curve: Curves.easeInOutCubic, // tab animation curves
                gap: 8, // the tab button gap between icon and text
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.search,
                    text: 'Search',
                  ),
                  GButton(
                    icon: Icons.person,
                    text: 'Profile',
                  )
                ]),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: "Add new patient",
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Get.to(PatientScreen());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
