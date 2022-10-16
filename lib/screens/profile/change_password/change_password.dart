import 'dart:math';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/components/form_error.dart';
import 'package:thecomein/components/password_form.dart';
import 'package:thecomein/constants.dart';
import 'package:thecomein/components/amplify_config.dart';
import 'package:thecomein/helper/comein_api.dart';
import 'package:thecomein/components/message.dart';
import 'package:thecomein/models/user_profile.dart';
import 'package:thecomein/routes.dart';

import 'package:thecomein/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePasswordScreen extends StatelessWidget {
  static String routeName = ROUTE_NAME_PASSWORD_CHANGE;

  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocale = AppLocalizations.of(context)!;
    ChangePasswordNavScreen screen =
        ChangePasswordNavScreen(titleText: appLocale.profile_change_password);

    return screen;
  }
}

class ResetPasswordPic extends StatelessWidget {
  const ResetPasswordPic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 200,
      // width: 200,
      child: Stack(
        fit: StackFit.expand,
        //overflow: Overflow.visible,
        children: [
          // CircleAvatar(
          //   backgroundImage: AssetImage("assets/images/reset_password.png"),
          // ),
        ],
      ),
    );
  }
}

class ChangePasswordNavScreen extends DefaultNavigatorScreen {
  final String titleText;

  const ChangePasswordNavScreen({Key? key, required this.titleText})
      : super(key: key, title: titleText);

  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordNavScreen();
  }
}

class _ChangePasswordNavScreen
    extends DefaultNavigatorScreenState<ChangePasswordNavScreen> {
  String username_email = '';

  callBE() async {
    var res = await Amplify.Auth.getCurrentUser();
    return res;
  }

  fetchEmail() async {
    this.onLoading(true);
    // var res = await Amplify.Auth.fetchUserAttributes();
    // UserInfo _info = initProfile(res);
    UserInfo _info = await ComeInAPI.profile();
    setState(() {
      username_email = _info.email;
    });

    print('username=$username_email');
    Future.delayed(
        loadingTimes,
        () => {
              this.onLoading(false),
            });
  }

  @override
  void initState() {
    super.initState();
    fetchEmail();
  }

  @override
  Widget buildBody(BuildContext context) {
    //print('build-body username=$username_email');
    return Column(children: [
      // ResetPasswordPic(),
      SizedBox(height: SizeConfig.screenHeight * 0.05),
      PasswordForm(
          email: username_email,
          isEditEmail: false,
          onSubmit: (_email, _password) =>
              doChangePassword(context, _email, _password)
          // onLoad: (_loading) {
          //   onLoadEvent(_loading);
          // },
          )
      // ChangePasswordForm(email: 'tawatchai'),
    ]);
  }

  void doChangePassword(
      BuildContext _context, String _email, String _password) {
    Navigator.pushNamed(_context, ROUTE_NAME_PASSWORD_CONFIRM_CHANGE,
        arguments: {"email": _email, "new_password": _password});
  }
}
