import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

messages(BuildContext context, String text) {
  var appLocale = appMsg(context);
  if (text == 'An account with the given email already exists.') {
    return appLocale.username_existing;
  } else if (text == 'Attempt limit exceeded, please try after some time.') {
    return appLocale.otp_exceeded_limit;
  } else if (text ==
      'Unexpected error occurred with message: Could not get end user to sign in.') {
    return appLocale.server_error_authen;
  } else if (text == 'Incorrect username or password.') {
    return appLocale.login_fail_wrong_username_password;
  } else {
    return text;
  }
}

appMsg(
  BuildContext context,
) {
  var appLocale = AppLocalizations.of(context)!;
  // var appLocale = null;
  return appLocale;
}

appMsgDelegate() {
  return AppLocalizations.delegate;
}

// class AppMessage {
//   final BuildContext context;
//   //final AppLocalizations appLocale ;
//   AppMessage(this.context);

//   String msg(String key) {
//     AppLocalizations appLocale = AppLocalizations.of(context)!;
//     reflect(appLocale);
//   }
// }
