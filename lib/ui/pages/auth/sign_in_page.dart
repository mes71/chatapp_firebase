import 'package:chatapp_firebase/data/db/db_helper.dart';
import 'package:chatapp_firebase/data/service/auth_service.dart';
import 'package:chatapp_firebase/data/service/data_base_service.dart';
import 'package:chatapp_firebase/data/utils/app_utils.dart';
import 'package:chatapp_firebase/generated/assets.dart';
import 'package:chatapp_firebase/ui/pages/auth/sign_up_page.dart';
import 'package:chatapp_firebase/ui/pages/home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  AuthService authService = AuthService();
  bool _isLoading = false;

  //TODO ADD EMAIl REGEX
  //TODO ADD Obsucre password TextField
  //TODO REMOVE SIGNUP Page And Add TO This page
  //TODO ADD bloc

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              'Firegram',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Login and connect to your freinds',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
            ),
            SvgPicture.asset(
              Assets.imageTalkingGroup,
              height: 300,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter some Text';
                  }
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(CupertinoIcons.envelope_fill),
                    labelText: 'Email'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter some Text';
                  }
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(CupertinoIcons.lock_fill),
                    labelText: 'Password'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(42),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  onPressed: () {
                    login();
                  },
                  child: Text('Sign In')),
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Don\'t have account ? ',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Colors.black87)),
              TextSpan(
                  text: 'Sign up here',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Theme.of(context).primaryColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      goToNextPage(context, SignUpPage());
                    }),
            ]))
          ],
        ),
      ),
    ));
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await authService
          .signInUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      )
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(_emailController.text);
          await DBHelper.setUserAuthStatus(true);
          await DBHelper.setUserPasswordSf(_passwordController.text);
          await DBHelper.setUserEmailSf(_emailController.text);
          await DBHelper.setUserNameSf(snapshot.docs[0]['fullName']);
          goReplaceToNextPage(context, const HomePage());
        } else {
          showSnackbar(value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: 2500),
        action: SnackBarAction(label: "Ok", onPressed: () {}),
      ),
    );
  }
}
