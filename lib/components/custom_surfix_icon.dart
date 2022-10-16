import 'package:thecomein/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSurffixIcon extends StatelessWidget {
  final String svgIcon;
  final double svgSize;
  final double paddingL;
  final double paddingT;
  final double paddingR;
  final double paddingB;

  const CustomSurffixIcon(
      {Key? key,
      required this.svgIcon,
      this.svgSize = 18.0,
      this.paddingL = 0,
      this.paddingT = 20,
      this.paddingR = 20,
      this.paddingB = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        paddingL,
        getProportionateScreenWidth(paddingT),
        getProportionateScreenWidth(paddingR),
        getProportionateScreenWidth(paddingB),
      ),
      child: SvgPicture.asset(
        svgIcon,
        height: getProportionateScreenWidth(svgSize),
      ),
    );
  }
}
