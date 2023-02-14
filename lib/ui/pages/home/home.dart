import 'package:chatapp_firebase/data/db/db_helper.dart';
import 'package:chatapp_firebase/data/service/auth_service.dart';
import 'package:chatapp_firebase/data/service/data_base_service.dart';
import 'package:chatapp_firebase/data/utils/app_utils.dart';
import 'package:chatapp_firebase/ui/pages/auth/sign_in_page.dart';
import 'package:chatapp_firebase/ui/pages/profile/profile_page.dart';
import 'package:chatapp_firebase/ui/pages/search/search_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String groupName = "";
  bool _isLoading = false;
  Stream? groups;

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
      body: groupList(),
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
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            popUpDialog(context);
          },
          child: Icon(CupertinoIcons.add)),
    );
  }

  void getUserData() async {
    await DBHelper.getUserNameSf().then((value) => setState(() {
          userName = value!;
        }));
    await DBHelper.getUserEmailSf().then((value) => setState(() {
          email = value!;
        }));

    await DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  groupList() {
    return StreamBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  var groupInfo =
                      snapshot.data['groups'][index].toString().split('_');
                  return getGroupTile(
                      groupName: groupInfo.last,
                      groupId: groupInfo.first,
                      fullName: snapshot.data['fullName']);
                },
                itemCount: snapshot.data['groups'].length,
              );
            } else {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.chat_bubble_text),
                    Text('Empty Groups')
                  ],
                ),
              );
            }
          } else {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.chat_bubble_text),
                  Text('Empty Groups')
                ],
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      stream: groups,
    );
  }

  void popUpDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Create a Group',
          textAlign: TextAlign.left,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : TextField(
                    onChanged: (value) {
                      setState(() {
                        groupName = value;
                      });
                    },
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  )
          ],
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                if (groupName != '') {
                  setState(() {
                    _isLoading = true;
                  });

                  DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                      .createGroup(userName,
                          FirebaseAuth.instance.currentUser!.uid, groupName)
                      .whenComplete(() => _isLoading = false);

                  Navigator.pop(context);
                  showModalBottomSheet(
                      context: context,
                      builder: (context) =>
                          Text('$groupName created successfully'));
                }
              },
              child: Text('Create')),
        ],
      ),
    );
  }

  Widget getGroupTile(
      {required String groupName,
      required String groupId,
      required String fullName}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Text(groupName.substring(0, 1).toUpperCase()),
      ),
      title: Text(
        groupName,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
