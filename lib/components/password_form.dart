import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/components/form_error.dart';
import 'package:thecomein/constants.dart';
import 'package:thecomein/components/message.dart';

import 'package:thecomein/size_config.dart';
import 'package:flutter/material.dart';

class PasswordForm extends StatefulWidget {
  final Function(String, String) onSubmit;

  //final String Function() onInit;
  // final Function(bool) onLoad;
  final bool isEditEmail;
  String email;

  PasswordForm(
      {Key? key,
      required this.onSubmit,
      // required this.onInit,
      this.isEditEmail = true,
      this.email = ''})
      : super(key: key);
  @override
  _PasswordForm createState() => _PasswordForm(onSubmit);
}

class _PasswordForm extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>();

  bool remember = false;
  final List<String> errors = [];
  late TextEditingController emailController; //= TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final Function(String, String) onSubmit;
  //final String Function() initEmail;

  // final Function(bool) onLoad;

  _PasswordForm(this.onSubmit);

  @override
  void initState() {
    super.initState();
  }

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

  // _submit(BuildContext context, String _email, String _password) async {
  //   final AppLocalizations appLocale = AppLocalizations.of(context)!;
  //   var okText = appLocale.ok;

  //   bool isNextOTP = true;
  //   String resText = '';
  //   try {
  //     onLoad(true);
  //   } on AuthException catch (e) {
  //     isNextOTP = false;
  //     print(e.message);

  //     resText = messages(context, e.message);
  //   }
  //   print('resText=$resText');
  //   Future.delayed(
  //       loadingTimes,
  //       () => {
  //             onLoad(false),
  //             // if (isNextOTP)
  //             //   {
  //             //     Navigator.push(
  //             //       context,
  //             //       MaterialPageRoute(
  //             //         builder: (context) => OtpScreen(),
  //             //         // Pass the arguments as part of the RouteSettings. The
  //             //         // DetailScreen reads the arguments from these settings.
  //             //         settings: RouteSettings(
  //             //           arguments: _email,
  //             //         ),
  //             //       ),
  //             //     ),
  //             //   }
  //             // else
  //             //   {ErrorAlert(context, resText)}

  //             // onLoad(false),
  //           });
  // }

  @override
  Widget build(BuildContext context) {
    //final AppLocalizations appLocale = AppLocalizations.of(context)!;
    var appLocale = appMsg(context);
    final String nextLabel = appLocale.next;
    emailController = TextEditingController(text: widget.email);
    //emailController.text = widget.email;
    // final userProfile =
    //     ModalRoute.of(context)!.settings.arguments as UserProfile;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          //buildEmailFormField(),
          // ,
          EmailTextField(
              readOnly: !widget.isEditEmail,
              controller: emailController,
              onRemoveError: removeError,
              onError: addError),
          //SizedBox(height: getProportionateScreenHeight(30)),
          // DefaultPasswordFeild(
          //   textController: passwordController,
          //   textLabel: appLocale.password,
          //   hintLabel: appLocale.password_hint,
          //   svgIcon: "assets/icons/Lock.svg",
          //   changeEvent: (value) {
          //     // print('password - $value');
          //     if (value!.isNotEmpty) {
          //       removeError(error: appLocale.password_required);
          //     }
          //     removeError(error: appLocale.password_min_length);
          //     removeError(error: appLocale.password_not_match);
          //   },
          //   validateEvent: (value) {
          //     //       // print('validate email: $value');
          //     if (value!.isEmpty) {
          //       addError(error: appLocale.password_required);
          //       return "";
          //     } else if (value.length < 8) {
          //       addError(error: appLocale.password_min_length);
          //       return "";
          //     }
          //     return null;
          //   },
          // ),
          NewPasswordTextField(
              controller: passwordController,
              onRemoveError: removeError,
              onError: addError),
          // buildPasswordFormField(appLocale),
          //SizedBox(height: getProportionateScreenHeight(30)),
          //  buildConformPassFormField(appLocale),
          ConfirmPasswordTextField(
              controller: confirmPasswordController,
              onRemoveError: removeError,
              onError: addError),
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
}

class NewPasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function({required String error}) onRemoveError;
  final Function({required String error}) onError;

  const NewPasswordTextField(
      {Key? key,
      required this.controller,
      required this.onRemoveError,
      required this.onError})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final AppLocalizations appLocale = AppLocalizations.of(context)!;
    var appLocale = appMsg(context);
    return DefaultPasswordFeild(
      textController: controller,
      textLabel: appLocale.new_password,
      hintLabel: appLocale.new_password_hint,
      svgIcon: "assets/icons/Lock.svg",
      changeEvent: (value) {
        // print('password - $value');
        if (value!.isNotEmpty) {
          onRemoveError(error: appLocale.password_required);
        }
        onRemoveError(error: appLocale.password_min_length);
        onRemoveError(error: appLocale.password_not_match);
      },
      validateEvent: (value) {
        //       // print('validate email: $value');
        if (value!.isEmpty) {
          onError(error: appLocale.password_required);
          return "";
        } else if (value.length < 8) {
          onError(error: appLocale.password_min_length);
          return "";
        }
        return null;
      },
    );
  }
}

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function({required String error}) onRemoveError;
  final Function({required String error}) onError;

  const PasswordTextField(
      {Key? key,
      required this.controller,
      required this.onRemoveError,
      required this.onError})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final AppLocalizations appLocale = AppLocalizations.of(context)!;
    var appLocale = appMsg(context);
    return DefaultPasswordFeild(
      textController: controller,
      textLabel: appLocale.password,
      hintLabel: appLocale.password_hint,
      svgIcon: "assets/icons/Lock.svg",
      changeEvent: (value) {
        // print('password - $value');
        if (value!.isNotEmpty) {
          onRemoveError(error: appLocale.password_required);
        }
      },
      validateEvent: (value) {
        //       // print('validate email: $value');
        if (value!.isEmpty) {
          onError(error: appLocale.password_required);
          return "";
        }
        return null;
      },
    );
  }
}

class ConfirmPasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function({required String error}) onRemoveError;
  final Function({required String error}) onError;

  const ConfirmPasswordTextField(
      {Key? key,
      required this.controller,
      required this.onRemoveError,
      required this.onError})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final AppLocalizations appLocale = AppLocalizations.of(context)!;
    var appLocale = appMsg(context);
    return DefaultPasswordFeild(
      textController: controller,
      textLabel: appLocale.confirm_password,
      hintLabel: appLocale.confirm_password_hint,
      svgIcon: "assets/icons/Lock.svg",
      changeEvent: (value) {
        if (value!.isNotEmpty) {
          onRemoveError(error: appLocale.confirm_password_required);
        }
        onRemoveError(error: appLocale.password_not_match);
      },
      validateEvent: (value) {
        //       // print('validate email: $value');
        if (value!.isEmpty) {
          onError(error: appLocale.confirm_password_required);
          return "";
        }
        return null;
      },
    );
  }
}

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function({required String error}) onRemoveError;
  final Function({required String error}) onError;
  final bool readOnly;

  const EmailTextField(
      {Key? key,
      required this.controller,
      required this.onRemoveError,
      required this.onError,
      this.readOnly = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final AppLocalizations appLocale = AppLocalizations.of(context)!;
    var appLocale = appMsg(context);
    return DefaultTextFeild(
      textController: controller,
      isReadOnly: readOnly,
      inputType: TextInputType.emailAddress,
      textLabel: appLocale.email,
      hintLabel: appLocale.email_hint,
      svgIcon: "assets/icons/Mail.svg",
      //changeEvent: (_email) => doChangeEmail(_email),
      changeEvent: (_email) => {
        //emailController.text = _email!,
        // print('change - $value');
        if (_email!.isNotEmpty)
          {
            onRemoveError(error: appLocale.email_required),
          },

        if (emailValidatorRegExp.hasMatch(_email))
          {
            onRemoveError(error: appLocale.email_invalid),
          }
      },
      // validateEvent: (_email) => doValidateEmail(_email),
      validateEvent: (_email) {
        if (_email!.isEmpty) {
          onError(error: appLocale.email_required);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(_email)) {
          onError(error: appLocale.email_invalid);
          return "";
        }
        return null;
      },
    );
  }
}
