import 'dart:ui';

import 'package:flutter/material.dart';

Color color1 = Color(0xFFBCF8EC);
Color color2 = Color(0xFFAED9E0);
Color color3 = Color(0xFF9FA0C3);
Color color4 = Color(0xFF8B687F);
Color color5 = Color(0xFF7B435B);

SizedBox spacingXS = SizedBox(height: 5);
SizedBox spacingS = SizedBox(height: 10);
SizedBox spacingsM = SizedBox(height: 20);
SizedBox spacingM = SizedBox(height: 25);
SizedBox spacingL = SizedBox(height: 35);
SizedBox spacingXL = SizedBox(height: 40);
SizedBox spacingXXL = SizedBox(height: 50);

SizedBox horizontalspacingXS = SizedBox(width: 5);
SizedBox horizontalspacingS = SizedBox(width: 10);
SizedBox horizontalspacingsM = SizedBox(width: 20);
SizedBox horizontalspacingM = SizedBox(width: 25);
SizedBox horizontalspacingL = SizedBox(width: 35);
SizedBox horizontalspacingXL = SizedBox(width: 40);
SizedBox horizontalspacingXXL = SizedBox(width: 50);

showToast(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    duration: Duration(seconds: 2),
  ));
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
