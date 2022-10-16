import 'package:thecomein/size_config.dart';
import 'package:thecomein/theme.dart';
import 'package:flutter/material.dart';

class SpaceBox extends StatelessWidget {
  final double height;

  const SpaceBox({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getScreenHeight(this.height / 100),
      width: double.infinity,
      child: const DecoratedBox(
        decoration: const BoxDecoration(color: kBGPrimaryColor),
      ),
    );
  }
}
