import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:store_project/view/cameraScreen.dart';
import 'package:store_project/view/homepage.dart';
import 'package:store_project/view/settingsScreen.dart';

import 'navbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _children = [HomePage(), CameraScreen(), settingsScreen()];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'My App',
        theme: theme,
        darkTheme: darkTheme,
        home: Scaffold(
          body: _children[_currentIndex],
          bottomNavigationBar: CustomNavBar(
            currentIndex: _currentIndex,
            onTap: onTabTapped,
          ),
        ),
      ),
    );
  }
}
