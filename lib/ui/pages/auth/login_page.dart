import 'package:chatapp_firebase/data/utils/app_utils.dart';
import 'package:chatapp_firebase/generated/assets.dart';
import 'package:chatapp_firebase/ui/pages/auth/sign_up_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //TODO ADD EMAIl REGEX
  //TODO ADD Obsucre password TextField
  //TODO REMOVE SIGNUP Page And Add TO This page
  //TODO ADD bloc

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                onPressed: () {},
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
    ));
  }
}
