import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/components/otp.dart';
import 'package:thecomein/components/message.dart';

import 'package:flutter/material.dart';

import 'package:thecomein/routes.dart';

class ForgetPasswordOtpScreen extends StatefulWidget {
  static String routeName = "/otp_forgot";
  final String home = ROUTE_NAME_SIGNIN;

  // final String event;

  const ForgetPasswordOtpScreen({
    Key? key,
    // this.home = SignInScreen.routeName,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ForgetPasswordOtpScreenState();
  }
}

class ForgetPasswordOtpScreenState
    extends DefaultScreen<ForgetPasswordOtpScreen> {
  late String _password;
  ForgetPasswordOtpScreenState() : super();

  String screenTitle(
    BuildContext context,
  ) {
    return 'forgot password';
  }

  @override
  Widget? appbarLeading() {
    return SizedBox();
  }

  @override
  Widget widgetBody(BuildContext context, OnLoadingCallback loading) {
    final params = ModalRoute.of(context)!.settings.arguments as Map;
    setState(() {
      _password = params['password'];
    });
    return OTPBody(
      onLoad: (_value) => loading(_value),
      home: widget.home,
      current: ForgetPasswordOtpScreen.routeName,
      next: '',
      sendOTP: doSendOTP,
      reSendOTP: doResendOTP,
    );
  }

  doSendOTP(String _email, String pin) async {
    print('do-send-otp by forgot-password');
    String resText = '';
    // bool isNext = false;

    onLoading(true);
    try {
      // var _email = _account.email;
      print('email=$_email otp=$pin');
      UpdatePasswordResult res = await Amplify.Auth.confirmResetPassword(
          username: _email, confirmationCode: pin, newPassword: _password);

      // isNext = true;
      Future.delayed(
          loadingTimes,
          () => {
                onLoading(false),
                // SuccessAlert(
                //   context,
                //   "Success",
                //   () => {
                Navigator.pushNamed(context, ROUTE_NAME_SIGNIN)
                //   },
                // ),
              });
    } on AuthException catch (e) {
      print('auth-exception:');
      // isNext = false;
      print(e.message);
      resText = messages(context, e.message);
      Future.delayed(
          loadingTimes,
          () => {
                onLoading(false),
                ErrorAlert(context, resText),
              });
    }
  }

  doResendOTP(_email) async {
    bool isNext = false;
    // var _email = _account.email;
    String resText = '';
    onLoading(true);
    try {
      ResendSignUpCodeResult res =
          await Amplify.Auth.resendSignUpCode(username: _email);
      isNext = true;
    } on AuthException catch (e) {
      print(e.message);

      resText = messages(context, e.message);
    }

    Future.delayed(
        loadingTimes,
        () => {
              onLoading(false),
              if (isNext)
                {
                  Navigator.pushReplacementNamed(
                      context, ForgetPasswordOtpScreen.routeName,
                      arguments: _email)
                }
              else
                {
                  ErrorAlert(context, resText),
                }
              // onLoad(false),
            });
  }
}
