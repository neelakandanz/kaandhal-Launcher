import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
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
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _getFormattedDate(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
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
