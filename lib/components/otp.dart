import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/components/amplify_config.dart';
import 'package:thecomein/components/message.dart';
import 'package:thecomein/size_config.dart';
import 'package:thecomein/theme.dart';
import 'package:flutter/material.dart';

class OTPBody extends StatefulWidget {
  final OnLoadingCallback onLoad;
  final String home;
  final String next;
  final String current;
  final Function(String, String) sendOTP;
  final Function(String) reSendOTP;

  const OTPBody(
      {Key? key,
      required this.onLoad,
      required this.home,
      required this.current,
      required this.next,
      required this.sendOTP,
      required this.reSendOTP})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return OTPBodyState();
  }
}

class OTPBodyState extends State<OTPBody> {
  late bool isOTPExpired;

  @override
  void initState() {
    print('init-state: otp expired = false');
    isOTPExpired = false;
    super.initState();
  }

  doBack2Home() {
    Navigator.pushNamed(context, widget.home);
  }

  // doSendOTP(String _email, String pin) async {
  //   print('do-send-otp');
  //   String resText = '';
  //   // bool isNext = false;
  //   widget.onLoad(true);
  //   try {
  //     // var _email = _account.email;
  //     print('email=$_email otp=$pin');
  //     SignUpResult res = await Amplify.Auth.confirmSignUp(
  //         username: _email, confirmationCode: pin);
  //     if (res.isSignUpComplete) {
  //       // isNext = true;
  //       Future.delayed(
  //           loadingTimes,
  //           () => {
  //                 widget.onLoad(false),
  //                 // SuccessAlert(
  //                 //   context,
  //                 //   "Success",
  //                 //   () => {
  //                 Navigator.pushNamed(context, widget.next)
  //                 //   },
  //                 // ),
  //               });
  //     }
  //   } on AuthException catch (e) {
  //     print('auth-exception:');
  //     // isNext = false;
  //     print(e.message);
  //     resText = messages(context, e.message);
  //     Future.delayed(
  //         loadingTimes,
  //         () => {
  //               widget.onLoad(false),
  //               ErrorAlert(context, resText),
  //             });
  //   }
  // }

  // doResendOTP(_email) async {
  //   bool isNext = false;
  //   // var _email = _account.email;
  //   String resText = '';
  //   widget.onLoad(true);
  //   try {
  //     ResendSignUpCodeResult res =
  //         await Amplify.Auth.resendSignUpCode(username: _email);
  //     isNext = true;
  //   } on AuthException catch (e) {
  //     print(e.message);

  //     resText = messages(context, e.message);
  //   }

  //   Future.delayed(
  //       loadingTimes,
  //       () => {
  //             widget.onLoad(false),
  //             if (isNext)
  //               {
  //                 Navigator.pushReplacementNamed(context, widget.current,
  //                     arguments: _email)
  //               }
  //             else
  //               {
  //                 ErrorAlert(context, resText),
  //               }
  //             // onLoad(false),
  //           });
  // }

  @override
  Widget build(BuildContext context) {
    //final AppLocalizations appLocale = AppLocalizations.of(context)!;
    var appLocale = appMsg(context);
    final String otpVerificationLabel = appLocale.otp_verification;
    final String otpTextLabel = appLocale.otp_text;

    final params = ModalRoute.of(context)!.settings.arguments as Map;
    String _email = params['email'];

    print('email=$_email');
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              Text(
                otpVerificationLabel,
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(otpTextLabel),
              buildTimer(context, 180.0),
              OtpForm(
                isExpired: isOTPExpired,
                sendOTP: widget.sendOTP,
                reSendOTP: widget.reSendOTP,
              ),

              SizedBox(height: SizeConfig.screenHeight * 0.01),
              DefaultButton(
                text: appLocale.back,
                press: () => doBack2Home(),
              ),
              // GestureDetector(
              //   onTap: () {
              //     print('reset-screen by refresh at new-screen');
              //     // OTP code resend
              //     Navigator.pushReplacement(
              //         context,
              //         MaterialPageRoute(
              //             builder: (BuildContext context) => OtpScreen(),
              //             settings: RouteSettings(
              //               arguments: _account,
              //             )));
              //   },
              //   child: Text(
              //     otpResendLabel,
              //     style: TextStyle(decoration: TextDecoration.underline),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Row buildTimer(BuildContext context, double sec) {
    var appLocale = appMsg(context);
    final String otpExpireLabel = appLocale.otp_expire_text;
    final String otpMinute = appLocale.otp_minute;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(otpExpireLabel),
        TweenAnimationBuilder(
          tween: Tween(begin: sec, end: 0.0),
          duration: Duration(seconds: sec.toInt()),
          builder: (_, value, child) => Timer2Text(timeObj: value),
          onEnd: () => {
            print('end-event'),
            setState(() {
              isOTPExpired = true;
            })
          },
        ),
      ],
    );
  }
}

class Timer2Text extends StatelessWidget {
  final Object? timeObj;

  const Timer2Text({Key? key, this.timeObj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final AppLocalizations appLocale = AppLocalizations.of(context)!;
    var appLocale = appMsg(context);
    final String otpMinute = appLocale.otp_minute;
    double times = timeObj as double;
    return Text(
      "0${(times.toInt() / 60).floor()}:${times.toInt() % 60} $otpMinute",
      style: TextStyle(color: kPrimaryColor),
    );
  }
}

class OtpForm extends StatefulWidget {
  final bool isExpired;
  final Function(String, String) sendOTP;
  final Function(String) reSendOTP;

  const OtpForm(
      {Key? key,
      required this.isExpired,
      required this.sendOTP,
      required this.reSendOTP})
      : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  late FocusNode pin2FocusNode;
  late FocusNode pin3FocusNode;
  late FocusNode pin4FocusNode;
  late FocusNode pin5FocusNode;
  late FocusNode pin6FocusNode;

  final p1Controller = TextEditingController();
  final p2Controller = TextEditingController();
  final p3Controller = TextEditingController();
  final p4Controller = TextEditingController();
  final p5Controller = TextEditingController();
  final p6Controller = TextEditingController();

  bool is6PIN = false;

  @override
  void initState() {
    print('init-state');
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
    p1Controller.text = '';
    p2Controller.text = '';
    p3Controller.text = '';
    p4Controller.text = '';
    p5Controller.text = '';
    p6Controller.text = '';
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
    pin5FocusNode.dispose();
    pin6FocusNode.dispose();
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  bool isPIN() {
    bool isP1 = p1Controller.text != '';
    bool isP2 = p2Controller.text != '';
    bool isP3 = p3Controller.text != '';
    bool isP4 = p4Controller.text != '';
    bool isP5 = p5Controller.text != '';
    bool isP6 = p6Controller.text != '';
    return isP1 && isP2 && isP3 && isP4 && isP5 && isP6;
  }

  @override
  Widget build(BuildContext context) {
    ComeInAmplifyConfig().init(context);
    // final AppLocalizations appLocale = AppLocalizations.of(context)!;
    var appLocale = appMsg(context);
    final String otpResendLabel = appLocale.otp_resend;
    //final String nextLabel = appLocale.next;

    final params = ModalRoute.of(context)!.settings.arguments as Map;

    String account_email = params['email'];
    double box_width = 45;
    double box_high = 20;
    return Form(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: getProportionateScreenWidth(box_width),
                child: TextFormField(
                  controller: p1Controller,
                  autofocus: true,
                  obscureText: true,
                  style: TextStyle(fontSize: box_high),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    setState(() {
                      is6PIN = isPIN();
                    });

                    nextField(value, pin2FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(box_width),
                child: TextFormField(
                    controller: p2Controller,
                    focusNode: pin2FocusNode,
                    obscureText: true,
                    style: TextStyle(fontSize: box_high),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {
                      setState(() {
                        is6PIN = isPIN();
                      });
                      nextField(value, pin3FocusNode);
                    }),
              ),
              SizedBox(
                width: getProportionateScreenWidth(box_width),
                child: TextFormField(
                  controller: p3Controller,
                  focusNode: pin3FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: box_high),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    setState(() {
                      is6PIN = isPIN();
                    });
                    nextField(value, pin4FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(box_width),
                child: TextFormField(
                  controller: p4Controller,
                  focusNode: pin4FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: box_high),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    setState(() {
                      is6PIN = isPIN();
                    });
                    nextField(value, pin5FocusNode);
                  },
                  // onChanged: (value) {
                  //   if (value.length == 1) {
                  //     pin4FocusNode.unfocus();
                  //     // Then you need to check is the code is correct or not
                  //   }
                  // },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(box_width),
                child: TextFormField(
                  controller: p5Controller,
                  focusNode: pin5FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: box_high),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    setState(() {
                      is6PIN = isPIN();
                    });
                    nextField(value, pin6FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(box_width),
                child: TextFormField(
                  controller: p6Controller,
                  focusNode: pin6FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: box_high),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    setState(() {
                      is6PIN = isPIN();
                    });
                    if (value.length == 1) {
                      pin6FocusNode.unfocus();
                      // Then you need to check is the code is correct or not
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          DefaultButton(
            text: appLocale.next,
            enable: !widget.isExpired && is6PIN,
            press: () {
              doSendOTP(account_email);
              // Navigator.pushNamed(context, SignInScreen.routeName);
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.01),
          DefaultButton(
            text: otpResendLabel,
            enable: widget.isExpired,
            press: () => doReSendOTP(account_email),
          ),
        ],
      ),
    );
  }

  doReSendOTP(String email) async {
    widget.reSendOTP(email);
    p1Controller.text = '';
    p2Controller.text = '';
    p3Controller.text = '';
    p4Controller.text = '';
    p5Controller.text = '';
    p6Controller.text = '';
  }

  doSendOTP(String email) async {
    var _p1 = p1Controller.text;
    var _p2 = p2Controller.text;
    var _p3 = p3Controller.text;
    var _p4 = p4Controller.text;
    var _p5 = p5Controller.text;
    var _p6 = p6Controller.text;
    var pin = _p1 + _p2 + _p3 + _p4 + _p5 + _p6;
    widget.sendOTP(email, pin);
    p1Controller.text = '';
    p2Controller.text = '';
    p3Controller.text = '';
    p4Controller.text = '';
    p5Controller.text = '';
    p6Controller.text = '';
    // try {
    //   var _email = account.email;
    //   print('email=$_email otp=$pin');
    //   SignUpResult res = await Amplify.Auth.confirmSignUp(
    //       username: _email, confirmationCode: pin);
    //   // setState(() {
    //   //   isSignUpComplete = res.isSignUpComplete;
    //   // });
    // } on AuthException catch (e) {
    //   print(e.message);
    // }
  }
}

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}
