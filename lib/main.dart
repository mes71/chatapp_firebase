import 'package:chatapp_firebase/data/db/db_helper.dart';
import 'package:chatapp_firebase/data/shared/constant.dart';
import 'package:chatapp_firebase/ui/pages/auth/login_page.dart';
import 'package:chatapp_firebase/ui/pages/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _userHasAuth = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _userHasAuth ? const HomePage() : const LoginPage(),
    );
  }

  @override
  void initState() {
    super.initState();

    getUserAuthStatus();
  }

  void getUserAuthStatus() async {
    await DBHelper.getUserAuthStatus().then((value) {
      if (value != null) {
        _userHasAuth = value;
      }
    });
  }
}
