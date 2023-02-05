import 'package:flutter/material.dart';

void goToNextPage(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => page,
  ));
}

void goReplaceToNextPage(BuildContext context, Widget page) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => page,
  ));
}
