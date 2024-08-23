import 'package:ab_service_app/config/preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;

import 'custom_card.dart';
import '../config/api_request.dart';
import '../ui-components/rounded_appbar.dart';
// import '../config/i10n.dart';
import 'detail_screen.dart';

User? loggedinUser;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  late List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getAppList();
    saveDevice();
  }

  void saveDevice() async {
    String? device = await getDeviceToken();
    if (device == null) {
      String? deviceToken;
      if (Platform.isIOS) {
        deviceToken = await FirebaseMessaging.instance.getAPNSToken();
      } else if (Platform.isAndroid) {
        deviceToken = await FirebaseMessaging.instance.getToken();
      }
      var data = {"deviceToken": deviceToken};
      final res = await ApiHttp().post('/addDevice', data);
      if (res['status'] == 200) saveDeviceToken(deviceToken!);
    }
  }

  //using this function you can use the credentials of the user
  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> getAppList() async {
    final res = await ApiHttp().get('/applist');
    setState(() {
      _data = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: RoundAppBar(
          titleName: "Main",
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: _data.length,
          itemBuilder: (BuildContext context, int index) {
            final item = _data[index];
            return CustomCard(
              logoUrl: item['logoUrl'] ??
                  '', // Provide a default value if logoUrl is null
              title: item['appname'] ?? '',
              content: item['description'] ?? '',
              onTap: () {
                _navigateToDetailScreen(
                    context, item); // Pass any details needed
              },
            );
          },
        ));
  }

  void _navigateToDetailScreen(BuildContext context, dynamic item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(item: item),
      ),
    );
  }
}
