import 'package:chatapp_firebase/data/db/db_helper.dart';
import 'package:chatapp_firebase/data/service/auth_service.dart';
import 'package:chatapp_firebase/data/utils/app_utils.dart';
import 'package:chatapp_firebase/ui/pages/auth/sign_in_page.dart';
import 'package:chatapp_firebase/ui/pages/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  String userName = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    await DBHelper.getUserNameSf().then((value) => setState(() {
          userName = value!;
        }));
    await DBHelper.getUserEmailSf().then((value) => setState(() {
          email = value!;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.person_alt_circle_fill,
              size: 150,
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Full name: "),
                Text(userName),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Email:"),
                Text(email),
              ],
            ),
          ],
        ),
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
              onTap: () {
                goReplaceToNextPage(context, HomePage());
              },
              title: Text('Groups'),
              leading: Icon(CupertinoIcons.group_solid),
            ),
            ListTile(
              selected: true,
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
    );
  }
}
