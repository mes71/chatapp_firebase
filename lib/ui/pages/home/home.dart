import 'package:chatapp_firebase/data/db/db_helper.dart';
import 'package:chatapp_firebase/data/service/auth_service.dart';
import 'package:chatapp_firebase/data/utils/app_utils.dart';
import 'package:chatapp_firebase/ui/pages/auth/sign_in_page.dart';
import 'package:chatapp_firebase/ui/pages/profile/profile_page.dart';
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
              height: 4,
            ),
            ListTile(
              selected: true,
              title: Text('Groups'),
              leading: Icon(CupertinoIcons.group_solid),
            ),
            ListTile(
              onTap: () {
                goReplaceToNextPage(context, ProfilePage());
              },
              title: Text('Profile'),
              leading: Icon(CupertinoIcons.person_alt),
            ),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Logout'),
                    content: Text('you sure logout?'),
                    actions: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.cancel_rounded,
                            color: Colors.red,
                          )),
                      IconButton(
                          onPressed: () async {
                            await authService.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => SignInPage(),
                                ),
                                (route) => false);
                          },
                          icon: Icon(
                            Icons.check,
                            color: Colors.green,
                          )),
                    ],
                  ),
                );
              },
              title: Text('Logout'),
              leading: Icon(Icons.logout_rounded),
            ),
          ],
        ),
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: () {}, child: Icon(Icons.chat)),
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
