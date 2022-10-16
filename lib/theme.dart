import 'package:flutter/material.dart';

const kBGPrimaryColor = Colors.white;
const kBorderPrimaryColor = Colors.black;
const kTextPrimaryColor = Colors.black;
const kTextSecondaryColor = Colors.black45;
const kPrimaryColor = Color(0xFF2196F3);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

ThemeData theme() {
  return ThemeData(
    //scaffoldBackgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.black,
    fontFamily: "Muli",
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    unselectedWidgetColor: kBorderPrimaryColor,
    // checkboxTheme: inputDecorationTheme();
    primaryTextTheme: textTheme(),
  );
}

ThemeData theme2() {
  return ThemeData(
    scaffoldBackgroundColor: kBGPrimaryColor,
    fontFamily: "Muli",
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    unselectedWidgetColor: kBorderPrimaryColor,
    // checkboxTheme: inputDecorationTheme();
    primaryTextTheme: textTheme(),
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: BorderSide(color: kBorderPrimaryColor),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    // If  you are using latest version of flutter then lable text and hint text shown like this
    // if you r using flutter less then 1.20.* then maybe this is not working properly
    // if we are define our floatingLabelBehavior in our theme then it's not applayed
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: contenPaddingInputStyle(30, 5),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    hintStyle: TextStyle(color: kTextSecondaryColor),
    labelStyle: labelInputStyle(25),
    //fillColor: Colors.red, filled: false,
    // counterStyle: TextStyle(color: Colors.red),
    border: outlineInputBorder,

    //ssuffixStyle: TextStyle(color: Colors.red),
  );
}

EdgeInsetsGeometry contenPaddingWidthInputStyle(double v) {
  return EdgeInsets.symmetric(horizontal: 30, vertical: v);
}

EdgeInsetsGeometry contenPaddingInputStyle(double h, double v) {
  return EdgeInsets.symmetric(horizontal: h, vertical: v);
}

TextStyle labelInputStyle(double font_size) {
  return TextStyle(color: kTextPrimaryColor, fontSize: font_size);
}

TextTheme textTheme() {
  return TextTheme(
    //bodyText1: TextStyle(color: kTextColor),
    //bodyText2: TextStyle(color: kTextColor),
    bodyText1: TextStyle(
      color: Colors.red,
    ),
    bodyText2: TextStyle(
      color: kTextPrimaryColor,
    ),
    button: TextStyle(color: Colors.yellow),
    caption: TextStyle(color: kTextPrimaryColor),
    headline6: TextStyle(color: kTextPrimaryColor),
    headline3: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
    headline4: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    //color: Colors.white,
    color: kBGPrimaryColor,
    elevation: 0,
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: Colors.black),

    textTheme: TextTheme(
      // headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
      headline6: TextStyle(color: kTextPrimaryColor, fontSize: 18),
    ),
  );
}
