import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';
import 'package:intl/intl.dart'; // Add this package for date formatting

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AppInfo>? apps;
  static const platform = MethodChannel('com.example.myapp/openApp');

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _fetchInstalledApps();
  }

  void _fetchInstalledApps() async {
    List<AppInfo> appList = await InstalledApps.getInstalledApps(true, true);
    setState(() {
      apps = appList;
    });
  }

  Future<void> _openApp(String packageName) async {
    try {
      final bool result =
          await platform.invokeMethod('openApp', {'packageName': packageName});
      if (result) {
        print('App opened successfully.');
      } else {
        print('Failed to open app.');
      }
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
    }
  }

  String _getFormattedTime() {
    return DateFormat('hh:mm a').format(DateTime.now()); // Format like '0724am'
  }

  String _getFormattedDate() {
    return DateFormat('EEE, MMM d yyyy')
        .format(DateTime.now()); // Format like 'Mon, Nov 4 2024'
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _getFormattedTime(),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              _getFormattedDate(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20),
            Expanded(
              child: apps == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: apps!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: apps![index].icon != null
                              ? Image.memory(apps![index].icon!)
                              : null,
                          title: Text(apps![index].name),
                          subtitle: Text(apps![index].packageName),
                          onTap: () => _openApp(apps![index].packageName),
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
