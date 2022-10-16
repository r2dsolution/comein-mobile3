import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/components/form_error.dart';
import 'package:thecomein/constants.dart';
import 'package:thecomein/components/amplify_config.dart';
import 'package:thecomein/helper/comein_api.dart';

import 'package:thecomein/components/message.dart';
import 'package:thecomein/models/user_profile.dart';
import 'package:thecomein/routes.dart';

import 'package:thecomein/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Amplify Flutter Packages

// Generated in previous step

class SignUpAccountScreen extends StatefulWidget {
  static String routeName = ROUTE_NAME_SIGNUP_ACCOUNT;

  const SignUpAccountScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _SignUpAccountScreen();
  }
}

// class _SignUpScreen extends DefaultScreen<SignUpScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return LoadingOverlayPro(
//       isLoading: isLoading,
//       progressIndicator: CupertinoActivityIndicator(radius: 100),
//       // overLoading: Text("Loading...",
//       //     style: TextStyle(color: Colors.black, fontSize: 20.0)),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(" ", style: Theme.of(context).textTheme.headline6),
//         ),
//         body: Body(
//           onLoad: (_value) => onLoading(_value),
//           // onEvent: (_event) => {
//           //       execute(_event),
//           //     }),
//         ),
//       ),
//     );
//   }
// }

class _SignUpAccountScreen extends DefaultScreen<SignUpAccountScreen> {
  @override
  Widget widgetBody(BuildContext context, OnLoadingCallback loading) {
    return Body(
      onLoad: (_value) => loading(_value),
    );
  }
}

class Body extends StatelessWidget {
  final OnLoadingCallback onLoad;
  //final ExecuteLoadingCallback? onEvent;

  const Body({
    Key? key,
    required this.onLoad,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ComeInAmplifyConfig().init(context);
    final _profile = ModalRoute.of(context)!.settings.arguments as UserProfile;
    // final AppLocalizations? appLocale = AppLocalizations.of(context);
    var appLocale = appMsg(context);
    final String usernameLabel = appLocale!.username;
    final String usernameTextLabel = appLocale.username_text;
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                // Text(
                //   usernameLabel,
                //   style: Theme.of(context).textTheme.headline4,
                // ),
                // Text(
                //   usernameTextLabel,
                //   textAlign: TextAlign.center,
                // ),
                DefaultTopicText(
                    label: usernameLabel, subLabel: usernameTextLabel),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignUpForm(
                    onSubmit: (_email, _password) =>
                        doRegister(context, _profile, _email, _password)),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     SocalCard(
                //       icon: "assets/icons/google-icon.svg",
                //       press: () {},
                //     ),
                //     SocalCard(
                //       icon: "assets/icons/facebook-2.svg",
                //       press: () {},
                //     ),
                //     SocalCard(
                //       icon: "assets/icons/twitter.svg",
                //       press: () {},
                //     ),
                //   ],
                // ),
                // SizedBox(height: getProportionateScreenHeight(20)),
                // Text(
                //   'By continuing your confirm that you agree \nwith our Term and Condition',
                //   textAlign: TextAlign.center,
                //   style: Theme.of(context).textTheme.caption,
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

// doNextOTP(UserProfile _profile, String _email) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => OtpScreen(),
//         // Pass the arguments as part of the RouteSettings. The
//         // DetailScreen reads the arguments from these settings.
//         settings: RouteSettings(
//           arguments: UserAccount(_profile, _email),
//         ),
//       ),
//     );
//   }
  doRegister(BuildContext context, UserProfile _profile, String _email,
      String _password) async {
    // final AppLocalizations appLocale = AppLocalizations.of(context)!;
    var appLocale = appMsg(context);
    var okText = appLocale.ok;

    bool isNextOTP = true;
    String resText = '';
    try {
      onLoad(true);
      Map<CognitoUserAttributeKey, String> userAttributes = {
        CognitoUserAttributeKey.email: _email,
        CognitoUserAttributeKey.givenName: _profile.firstname,
        CognitoUserAttributeKey.familyName: _profile.lastname,
        CognitoUserAttributeKey.phoneNumber: _profile.phone(),
        CognitoUserAttributeKey.name: _profile.refname,
        ComeInAPI.comeInIDCognitoKey: ComeInAPI.getUUID(),
        // additional attributes as needed
      };
      SignUpResult res = await Amplify.Auth.signUp(
          username: _email,
          password: _password,
          options: CognitoSignUpOptions(userAttributes: userAttributes));

      // LoadingEvent e = LoadingEvent.initEvent(
      //     () => {
      //           print('start to register'),
      //           Amplify.Auth.signUp(
      //               username: _email,
      //               password: _password,
      //               options:
      //                   CognitoSignUpOptions(userAttributes: userAttributes)),
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => OtpScreen(),
      //               // Pass the arguments as part of the RouteSettings. The
      //               // DetailScreen reads the arguments from these settings.
      //               settings: RouteSettings(
      //                 arguments: UserAccount(_profile, _email),
      //               ),
      //             ),
      //           ),
      //         },
      //     (_bool) => onLoad(_bool));

      // onEvent(e);
    } on AuthException catch (e) {
      isNextOTP = false;
      print(e.message);

      resText = messages(context, e.message);
      onLoad(false);
      ErrorAlert(context, resText);
    }
    print('resText=$resText');
    Future.delayed(
        loadingTimes,
        () => {
              onLoad(false),
              if (isNextOTP)
                {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => OtpScreen(),
                  //     // Pass the arguments as part of the RouteSettings. The
                  //     // DetailScreen reads the arguments from these settings.
                  //     settings: RouteSettings(
                  //       arguments: _email,
                  //     ),
                  //   ),
                  // ),
                  Navigator.pushNamed(context, ROUTE_NAME_SIGNUP_OTP,
                      arguments: _email)
                }
              else
                {ErrorAlert(context, resText)}

              // onLoad(false),
            });
  }
}

class SignUpForm extends StatefulWidget {
  final Function(String, String) onSubmit;

  const SignUpForm({Key? key, required this.onSubmit}) : super(key: key);
  @override
  _SignUpFormState createState() => _SignUpFormState(onSubmit);
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  bool remember = false;
  final List<String> errors = [];
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final Function(String, String) onSubmit;

  _SignUpFormState(this.onSubmit);

  void addError({required String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({required String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  doChangeEmail(String? _email) {
    // print('change - $value');
    if (_email!.isNotEmpty) {
      removeError(error: kEmailNullError);
    }

    if (emailValidatorRegExp.hasMatch(_email)) {
      removeError(error: kInvalidEmailError);
    }
    return null;
  }

  doValidateEmail(String? _email) {
    print('validate - $_email');
    if (_email!.isEmpty) {
      addError(error: kEmailNullError);
      return "";
    } else if (!emailValidatorRegExp.hasMatch(_email)) {
      addError(error: kInvalidEmailError);
      return "";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // final AppLocalizations appLocale = AppLocalizations.of(context)!;
    var appLocale = appMsg(context);
    final String nextLabel = appLocale.next;
    // final userProfile =
    //     ModalRoute.of(context)!.settings.arguments as UserProfile;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          //buildEmailFormField(),
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
          //SizedBox(height: getProportionateScreenHeight(30)),
          DefaultPasswordFeild(
            textController: passwordController,
            textLabel: appLocale.password,
            hintLabel: appLocale.password_hint,
            svgIcon: "assets/icons/Lock.svg",
            changeEvent: (value) {
              // print('password - $value');
              if (value!.isNotEmpty) {
                removeError(error: appLocale.password_required);
              }
              removeError(error: appLocale.password_min_length);
              removeError(error: appLocale.password_not_match);
            },
            validateEvent: (value) {
              //       // print('validate email: $value');
              if (value!.isEmpty) {
                addError(error: appLocale.password_required);
                return "";
              } else if (value.length < 8) {
                addError(error: appLocale.password_min_length);
                return "";
              }
              return null;
            },
          ),
          // buildPasswordFormField(appLocale),
          //SizedBox(height: getProportionateScreenHeight(30)),
          //  buildConformPassFormField(appLocale),
          DefaultPasswordFeild(
            textController: confirmPasswordController,
            textLabel: appLocale.confirm_password,
            hintLabel: appLocale.confirm_password_hint,
            svgIcon: "assets/icons/Lock.svg",
            changeEvent: (value) {
              if (value!.isNotEmpty) {
                removeError(error: appLocale.confirm_password_required);
              }
              removeError(error: appLocale.password_not_match);
            },
            validateEvent: (value) {
              //       // print('validate email: $value');
              if (value!.isEmpty) {
                addError(error: appLocale.confirm_password_required);
                return "";
              }
              return null;
            },
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: nextLabel,
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                var password = passwordController.text;
                var confirm_password = confirmPasswordController.text;
                if (password == confirm_password) {
                  removeError(error: appLocale.password_not_match);
                  String email = emailController.text;
                  print('email = $email');
                  // doRegister(userProfile, email, password);
                  //LoadingEvent.initEvent(onSubmit(email, password), null);
                  onSubmit(email, password);
                  //doNextOTP(userProfile, email);
                  // Navigator.pushNamed(context, OtpScreen.routeName);
                } else {
                  addError(error: appLocale.password_not_match);
                }
                // if all are valid then go to success screen

              }
            },
          ),
        ],
      ),
    );
  }

  // TextFormField buildConformPassFormField(AppLocalizations appLocale) {
  //   final String confirmPasswordLabel = appLocale.confirm_password;
  //   final String confirmPasswordHintLabel = appLocale.confirm_password_hint;
  //   return TextFormField(
  //     style: TextStyle(color: kTextColor),
  //     obscureText: true,
  //     onSaved: (newValue) => conform_password = newValue,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: kPassNullError);
  //       }
  //     },
  //     validator: (value) {
  //       // print('password=$password');
  //       // print('confirm-password=$conform_password');
  //       if (value.isEmpty) {
  //         addError(error: kPassNullError);
  //         return "";
  //       }

  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: confirmPasswordLabel,
  //       hintText: confirmPasswordHintLabel,
  //       helperText: ' ',
  //       helperStyle: TextStyle(color: Colors.white),
  //       // If  you are using latest version of flutter then lable text and hint text shown like this
  //       // if you r using flutter less then 1.20.* then maybe this is not working properly
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
  //     ),
  //   );
  // }

  // TextFormField buildPasswordFormField(AppLocalizations appLocale) {
  //   final String passwordLabel = appLocale.password;
  //   final String passwordHintLabel = appLocale.password_hint;
  //   return TextFormField(
  //     style: TextStyle(color: kTextPrimaryColor),
  //     obscureText: true,
  //     onSaved: (newValue) => password = newValue,
  //     validator: (value) {
  //       // print('validate email: $value');
  //       if (value.isEmpty) {
  //         addError(error: kPassNullError);
  //         return "";
  //       } else if (value.length < 8) {
  //         addError(error: kShortPassError);
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: passwordLabel,
  //       hintText: passwordHintLabel,
  //       helperText: ' ',
  //       helperStyle: TextStyle(color: Colors.white),

  //       // If  you are using latest version of flutter then lable text and hint text shown like this
  //       // if you r using flutter less then 1.20.* then maybe this is not working properly
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
  //     ),
  //   );
  // }

  // TextFormField buildEmailFormField(AppLocalizations appLocale) {
  //   final String emailLabel = appLocale.email;
  //   final String emailHintLabel = appLocale.email_hint;
  //   return TextFormField(
  //     keyboardType: TextInputType.emailAddress,
  //     onSaved: (newValue) => email = newValue,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: kEmailNullError);
  //       } else if (emailValidatorRegExp.hasMatch(value)) {
  //         removeError(error: kInvalidEmailError);
  //       }
  //       return null;
  //     },
  //     validator: (value) {
  //       if (value.isEmpty) {
  //         addError(error: kEmailNullError);
  //         return "";
  //       } else if (!emailValidatorRegExp.hasMatch(value)) {
  //         addError(error: kInvalidEmailError);
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: emailLabel,
  //       hintText: emailHintLabel,
  //       // If  you are using latest version of flutter then lable text and hint text shown like this
  //       // if you r using flutter less then 1.20.* then maybe this is not working properly
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
  //     ),
  //   );
  // }
}
