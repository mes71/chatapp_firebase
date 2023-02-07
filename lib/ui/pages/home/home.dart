import 'package:chatapp_firebase/data/db/db_helper.dart';
import 'package:chatapp_firebase/data/service/auth_service.dart';
import 'package:chatapp_firebase/data/utils/app_utils.dart';
import 'package:chatapp_firebase/ui/pages/search/search_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  String userName = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                goToNextPage(context, SearchScreen());
              },
              icon: Icon(CupertinoIcons.search))
        ],
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              authService.signOut();
            },
            child: Text('SignOut')),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(
              CupertinoIcons.person_alt_circle_fill,
              size: 150,
            ),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            SizedBox(
              height: 30,
            ),
            Divider(
              height: 2,
            )
          ],
        ),
      ),
    );
  }

  void getUserData() async {
    await DBHelper.getUserNameSf().then((value) => setState(() {
          userName = value!;
        }));
    await DBHelper.getUserEmailSf().then((value) => setState(() {
          email = value!;
        }));
  }
}
