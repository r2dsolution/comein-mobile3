import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  static late Orientation orientation;
  static double screenPadding = 20;
  static double appBarHeight = 50;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    appBarHeight = screenHeight * 0.05;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}

double getPercentScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  double result = (inputWidth * screenWidth) / 90.0;
  // print('screen-width: $screenWidth widget-width: $result');
  return result;
}

double getPercentScreenHeight(double input) {
  double totalHeight = SizeConfig.screenHeight - SizeConfig.appBarHeight;
//  print('total-height: $totalHeight');
  double screen = totalHeight * 0.9;
  // 375 is the layout width that designer use
  double result = (input * screen) / 90.0;
  // print('screen-height: $input widget-height: $result');
  return result;
}

double getScreenHeight(double input) {
  double totalHeight = SizeConfig.screenHeight - SizeConfig.appBarHeight;
  //print('total-height: $totalHeight');
  double screen = totalHeight * 0.9;
  // 375 is the layout width that designer use
  double result = (input * screen);
  //print('screen-height: $input widget-height: $result');
  return result;
}

double getPaddingVertical(double input) {
  double totalHeight = SizeConfig.screenHeight - SizeConfig.appBarHeight;
  // print('total height $totalHeight');

  if (totalHeight > 900) return 10;
  if (totalHeight > 875) return 10;
  if (totalHeight > 850) return 10;
  if (totalHeight > 800) return 10;
  if (totalHeight > 700) return 10;
  if (totalHeight > 600) return 10;
  return input;
}

double getFontSize(double input) {
  double totalHeight = SizeConfig.screenHeight - SizeConfig.appBarHeight;

  /// print('total height $totalHeight');

  if (totalHeight > 900) return 25;
  if (totalHeight > 875) return 20;
  if (totalHeight > 850) return 19;
  if (totalHeight > 800) return 18;
  if (totalHeight > 700) return 17;
  if (totalHeight > 600) return 16;
  return input;
}

double getLabelFontSize(double input) {
  double totalHeight = SizeConfig.screenHeight - SizeConfig.appBarHeight;
//  print('total height $totalHeight');

  if (totalHeight > 900) return 25;
  if (totalHeight > 875) return 20;
  if (totalHeight > 850) return 19;
  if (totalHeight > 800) return 18;
  if (totalHeight > 700) return 17;
  if (totalHeight > 600) return 25;
  return input;
}

double getSubFontSize(double input) {
  double totalHeight = SizeConfig.screenHeight - SizeConfig.appBarHeight;
  // print('total height $totalHeight');

  if (totalHeight > 900) return 22;
  if (totalHeight > 875) return 18;
  if (totalHeight > 850) return 17;
  if (totalHeight > 800) return 16;
  if (totalHeight > 700) return 15;
  if (totalHeight > 600) return 14;
  return input;
}
