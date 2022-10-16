import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/components/form_error.dart';
import 'package:thecomein/components/password_form.dart';
import 'package:thecomein/constants.dart';
import 'package:thecomein/components/message.dart';
import 'package:thecomein/models/user_profile.dart';
import 'package:thecomein/routes.dart';

import 'package:thecomein/size_config.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String routeName = ROUTE_NAME_PASSWORD_FORGOT;

  const ForgotPasswordScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ForgotPasswordScreenState();
  }
}

class ForgotPasswordScreenState extends DefaultScreen<ForgotPasswordScreen> {
  @override
  Widget widgetBody(BuildContext context, OnLoadingCallback loading) {
    return Body(
      onLoad: (_value) => loading(_value),
    );
  }
}

class Body extends StatefulWidget {
  final OnLoadingCallback onLoad;

  const Body({Key? key, required this.onLoad}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return BodyState();
  }
}

class BodyState extends State<Body> {
  doResetPassword(String _email, String _password) async {
    String resText = '';
    widget.onLoad(true);
    try {
      ResetPasswordResult res =
          await Amplify.Auth.resetPassword(username: _email);
      print('waiting response');

      Future.delayed(
          loadingTimes,
          () => {
                widget.onLoad(false),

                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (BuildContext context) =>
                //             ForgetPasswordOtpScreen(),
                //         settings: RouteSettings(
                //           arguments: {"email": _email, "password": _password},
                //         )))
                Navigator.pushNamed(context, ROUTE_NAME_PASSWORD_OTP,
                    arguments: {"email": _email, "password": _password})
                // onLoad(false),
              });

      print('response completed.');
    } on AuthException catch (e) {
      print(e.message);

      resText = messages(context, e.message);
      Future.delayed(
          loadingTimes,
          () => {
                widget.onLoad(false),

                ErrorAlert(context, resText),

                // onLoad(false),
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final AppLocalizations appLocale = AppLocalizations.of(context)!;
    var appLocale = appMsg(context);
    final String forgotPasswordLabel = appLocale.forgot_password;
    final String forgotPasswordTextLabel = appLocale.forgot_password_text;
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              // Text(
              //   forgotPasswordLabel,
              //   style: Theme.of(context).textTheme.headline4,
              // ),
              // Text(
              //   forgotPasswordTextLabel,
              //   textAlign: TextAlign.center,
              // ),
              DefaultTopicText(
                  label: forgotPasswordLabel,
                  subLabel: forgotPasswordTextLabel),
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              // ForgotPassForm(
              //   onResetPassword: doResetPassword,
              // ),
              PasswordForm(onSubmit: doResetPassword)
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  final Function(String) onResetPassword;

  const ForgotPassForm({Key? key, required this.onResetPassword})
      : super(key: key);
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  final emailController = TextEditingController();
  // String email;
  // String password;

  void addError({String error = ''}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error = ''}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    //final AppLocalizations appLocale = AppLocalizations.of(context)!;
    var appLocale = appMsg(context);
    final String emailLabel = appLocale.email;
    final String emailHintLabel = appLocale.email_hint;
    final String nextLabel = appLocale.next;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DefaultTextFeild(
            textController: emailController,
            inputType: TextInputType.emailAddress,
            textLabel: appLocale.email,
            hintLabel: appLocale.email_hint,
            svgIcon: "assets/icons/Mail.svg",
            //changeEvent: (_email) => doChangeEmail(_email),
            changeEvent: (_email) => {
              // print('change - $value');
              if (_email!.isNotEmpty)
                {
                  removeError(error: appLocale.email_required),
                },

              if (emailValidatorRegExp.hasMatch(_email))
                {
                  removeError(error: appLocale.email_invalid),
                }
            },
            // validateEvent: (_email) => doValidateEmail(_email),
            validateEvent: (_email) {
              if (_email!.isEmpty) {
                addError(error: appLocale.email_required);
                return "";
              } else if (!emailValidatorRegExp.hasMatch(_email)) {
                addError(error: appLocale.email_invalid);
                return "";
              }
              return null;
            },
          ),
          // SizedBox(height: getProportionateScreenHeight(30)),
          // buildPasswordFormField(appLocale),
          //SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: SizeConfig.screenHeight * 0.05),
          DefaultButton(
            text: nextLabel,
            press: () {
              if (_formKey.currentState!.validate()) {
                // Do what you want to do
                widget.onResetPassword(emailController.text);
                // Navigator.pushNamed(context, OtpPasswordScreen.routeName);
              }
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          //  NoAccountText(),
        ],
      ),
    );
    // return Text("hello");
  }

  // void addError({required String error}) {
  //   if (!errors.contains(error))
  //     setState(() {
  //       errors.add(error);
  //     });
  // }
}
