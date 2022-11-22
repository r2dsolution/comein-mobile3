import 'package:thecomein/constants.dart';
import 'package:thecomein/routes.dart';
import 'package:thecomein/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    print('select-menu:' + selectedMenu.toString());
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    final Color activeIconColor = Colors.blue;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(FontAwesomeIcons.home,
                    color: MenuState.home == selectedMenu
                        ? activeIconColor
                        : inActiveIconColor),
                onPressed: () =>
                    Navigator.pushNamed(context, ROUTE_NAME_MAIN_BOOKING),
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.suitcaseRolling,
                    color: MenuState.tourBooking == selectedMenu
                        ? activeIconColor
                        : inActiveIconColor),
                onPressed: () =>
                    Navigator.pushNamed(context, ROUTE_NAME_TOUR_BOOKING),
              ),

              // IconButton(
              //   icon: SvgPicture.asset("assets/icons/Chat.svg"),
              //   onPressed: () {},
              // ),
              IconButton(
                icon: SvgPicture.asset("assets/icons/Chat.svg",
                    color: MenuState.activities == selectedMenu
                        ? activeIconColor
                        : inActiveIconColor),
                onPressed: () =>
                    Navigator.pushNamed(context, ROUTE_NAME_ACTIVITIES_BOARD),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/User.svg",
                  color: MenuState.profile == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, ROUTE_NAME_PROFILE_VIEW),
              ),
            ],
          )),
    );
  }
}
