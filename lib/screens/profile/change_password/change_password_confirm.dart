import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/components/form_error.dart';
import 'package:thecomein/components/password_form.dart' as PasswordForm;
import 'package:thecomein/components/message.dart';
import 'package:thecomein/routes.dart';

//import 'package:comein/screens/sign_in_screen.dart' as SignIn;
import 'package:thecomein/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmChangePasswordScreen extends StatelessWidget {
  static String routeName = "/confirm_change_password";

  const ConfirmChangePasswordScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocale = AppLocalizations.of(context)!;
    return ConfirmChangePasswordNavScreen(
        titleText: appLocale.profile_confirm_change_password);
  }
}

class ConfirmChangePasswordNavScreen extends DefaultNavigatorScreen {
  final String titleText;

  const ConfirmChangePasswordNavScreen({Key? key, required this.titleText})
      : super(key: key, title: titleText);

  @override
  State<StatefulWidget> createState() {
    return _ConfirmChangePasswordNavScreen();
  }
}

class _ConfirmChangePasswordNavScreen
    extends DefaultNavigatorScreenState<ConfirmChangePasswordNavScreen> {
  @override
  Widget buildBody(BuildContext context) {
    //print('build-body username=$username_email');
    return Column(children: [
      // ResetPasswordPic(),
      SizedBox(height: SizeConfig.screenHeight * 0.05),
      ConfirmChangePasswordForm(
        onSubmit: doResetPassword,
      ),

      // ChangePasswordForm(email: 'tawatchai'),
    ]);
  }

  doResetPassword(String email, String password, String newPassword) async {
    final AppLocalizations appLocale = AppLocalizations.of(context)!;
    print('reset-password email=$email');
    onLoading(true);
    try {
      await Amplify.Auth.updatePassword(
          newPassword: newPassword, oldPassword: password);
      await Amplify.Auth.signOut();
      Future.delayed(
          loadingTimes,
          () => {
                onLoading(false),
                SuccessAlert(context, appLocale.save_success, goToLogout),
              });
    } on AmplifyException catch (e) {
      print(e);
      String resText = messages(context, e.message);
      Future.delayed(loadingTimes, () => {onLoading(false)});
      ErrorAlert(context, resText);
    }
  }

  goToLogout() {
    print('logout');
    Navigator.pushNamed(context, ROUTE_NAME_SIGNIN);
  }
}

class ConfirmChangePasswordForm extends StatefulWidget {
  final Function(String, String, String) onSubmit;
  const ConfirmChangePasswordForm({Key? key, required this.onSubmit})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ConfirmChangePasswordForm();
  }
}

class _ConfirmChangePasswordForm extends State<ConfirmChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController emailController;
  final passwordController = TextEditingController();
  final List<String> errors = [];
  String email = '';

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

  @override
  Widget build(BuildContext context) {
    final params = ModalRoute.of(context)!.settings.arguments as Map;
    final String newPassword = params['new_password'];
    emailController = TextEditingController(text: params['email']);
    final AppLocalizations appLocale = AppLocalizations.of(context)!;
    final String nextLabel = appLocale.next;
    return Form(
        key: _formKey,
        child: Column(children: [
          PasswordForm.EmailTextField(
              readOnly: true,
              controller: emailController,
              onRemoveError: removeError,
              onError: addError),
          PasswordForm.PasswordTextField(
              controller: passwordController,
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

                String email = emailController.text;
                print('email = $email');
                widget.onSubmit(email, password, newPassword);
                // if all are valid then go to success screen

              }
            },
          ),
        ]));
  }
}
