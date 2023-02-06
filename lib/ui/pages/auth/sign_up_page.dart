import 'package:chatapp_firebase/data/db/db_helper.dart';
import 'package:chatapp_firebase/data/service/auth_service.dart';
import 'package:chatapp_firebase/data/utils/app_utils.dart';
import 'package:chatapp_firebase/generated/assets.dart';
import 'package:chatapp_firebase/ui/pages/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              )
            : SingleChildScrollView(
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 48),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Sign up and create your team',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 15),
                      ),
                      SvgPicture.asset(
                        Assets.imageCreateGroup,
                        height: 300,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextFormField(
                          controller: _fullNameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter some Text';
                            }
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(CupertinoIcons.person_alt),
                              labelText: 'Full Name'),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter some Text';
                            }
                          },
                          controller: _emailController,
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
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter some Text';
                            }
                          },
                          controller: _passwordController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(CupertinoIcons.lock_fill),
                              labelText: 'Password'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 20),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size.fromHeight(42),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            onPressed: () {
                              register();
                            },
                            child: Text('Sign In')),
                      ),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'have account ? ',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: Colors.black87)),
                        TextSpan(
                            text: 'Sign In here',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: Theme.of(context).primaryColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pop();
                              }),
                      ]))
                    ],
                  ),
                ),
              ));
  }

  register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await authService
          .registerUserWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text,
              fullName: _fullNameController.text)
          .then((value) async {
        if (value) {
          await DBHelper.setUserAuthStatus(true);
          await DBHelper.setUserNameSf(_fullNameController.text);
          await DBHelper.setUserPasswordSf(_passwordController.text);
          await DBHelper.setUserEmailSf(_emailController.text);
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
        backgroundColor: Colors.grey.shade200,
        duration: Duration(milliseconds: 2500),
        action: SnackBarAction(label: "Ok", onPressed: () {}),
      ),
    );
  }
}
