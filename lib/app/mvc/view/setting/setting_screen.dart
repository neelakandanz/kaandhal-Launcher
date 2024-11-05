import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Open System Settings'),
            onTap: _openSystemSettings,
          ),
          ListTile(
            leading: const Icon(Icons.format_paint),
            title: const Text('Choose Background Theme'),
            onTap: () {
              // Add your background theme change logic here
              log('Navigate to background theme screen');
            },
          ),
        ],
      ),
    );
  }

  void _openSystemSettings() async {
    const platform = MethodChannel('com.example.myapp/openApp');
    try {
      await platform.invokeMethod('openApp', {'packageName': 'com.android.settings'});
      log('Opened system settings');
    } on PlatformException catch (e) {
      log('Error opening system settings: ${e.message}');
    }
  }
}
