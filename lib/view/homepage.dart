import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:store_project/view/cameraScreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final themeMode = AdaptiveTheme.of(context).mode;
          if (themeMode == AdaptiveThemeMode.dark) {
            AdaptiveTheme.of(context).setThemeMode(AdaptiveThemeMode.light);
          } else {
            AdaptiveTheme.of(context).setThemeMode(AdaptiveThemeMode.dark);
          }
        },
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          child: Icon(
            AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode,
            key: ValueKey<bool>(
                AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark),
            size: 24,
          ),
        ),
      ),
    );
  }
}
