import 'package:flutter/material.dart';
import 'package:healthlink/FeaturePage.dart';
import 'package:healthlink/mainPage.dart';
import 'package:healthlink/profilePage.dart';
import 'package:healthlink/recordPage.dart';

class HomePage extends StatefulWidget {

  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int index = 0;
  final screens = [
      MainPage(),
      FeaturePage(),
      FeaturePage()

  ];

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: screens[index],
        extendBody: true,
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              indicatorColor: Colors.transparent,
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              labelTextStyle: MaterialStateProperty.all(
                TextStyle(fontSize: 14, fontWeight: FontWeight.w500)
              )
          ),
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            animationDuration: const Duration(milliseconds: 1500),
            elevation: 0,
            selectedIndex: index,
            onDestinationSelected: (index) {
              setState(() {
                this.index = index;
              });
            },
            destinations: [
              NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_outlined, color: Color(0xFFEF8808),), label: "Home"),
              NavigationDestination(icon: Icon(Icons.account_circle_outlined), selectedIcon: Icon(Icons.account_circle_outlined, color: Color(0xFFEF8808),), label: "Profile"),
              NavigationDestination(icon: Icon(Icons.health_and_safety_outlined), selectedIcon: Icon(Icons.health_and_safety_outlined, color: Color(0xFFEF8808),),label: "Record")
            ],
          ),
        ),
      );
  }
}
