import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/components/message.dart';
import 'package:thecomein/routes.dart';

import 'package:thecomein/size_config.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  static String routeName = ROUTE_NAME_PROFILE_EDIT;

  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final params = ModalRoute.of(context)!.settings.arguments as Map;
    // final AppLocalizations appLocale = AppLocalizations.of(context)!;
    var appLocale = appMsg(context);
    return EditProfileNavigatorScreen(
      titleText: appLocale.profile_edit,
    );
  }
}

class EditProfileNavigatorScreen extends DefaultNavigatorScreen {
  final String titleText;

  const EditProfileNavigatorScreen({Key? key, required this.titleText})
      : super(key: key, title: titleText);

  @override
  State<StatefulWidget> createState() {
    return _EditProfileNavigatorScreen();
  }
}

class _EditProfileNavigatorScreen
    extends DefaultNavigatorScreenState<EditProfileNavigatorScreen> {
  //String profileValue;
  late TextEditingController valueEditController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final params = ModalRoute.of(context)!.settings.arguments as Map;
      setState(() {
        valueEditController = TextEditingController(text: params['attr_value']);
      });
    });
  }

  @override
  Widget buildBody(BuildContext context) {
    final params = ModalRoute.of(context)!.settings.arguments as Map;
    // final AppLocalizations appLocale = AppLocalizations.of(context)!;
    var appLocale = appMsg(context);
    // valueEditController = TextEditingController(text: params['attr_value']);
    UserAttributeKey attr_id = params['attr_id'];
    return Column(children: [
      SizedBox(height: SizeConfig.screenHeight * 0.05),
      DefaultTextFeild(
          textController: valueEditController,
          svgIcon: 'assets/icons/User.svg',
          hintLabel: '',
          textLabel: params['attr_name']),
      SizedBox(height: SizeConfig.screenHeight * 0.05),
      DefaultButton(
          text: appLocale.save,
          press: () {
            ConfirmAlert(
                context: context,
                message: appLocale.profile_confirm_change,
                onOK: () => {
                      print('ok.'),
                      doChangeAttr(attr_id, valueEditController.text),
                    });
          })
    ]);
  }

  doChangeAttr(UserAttributeKey key, _value) async {
    try {
      Navigator.pop(context);
      onLoading(true);
      var res = await Amplify.Auth.updateUserAttribute(
        userAttributeKey: key,
        value: _value,
      );
      if (res.nextStep.updateAttributeStep == 'CONFIRM_ATTRIBUTE_WITH_CODE') {
        var destination = res.nextStep.codeDeliveryDetails?.destination;
        print('Confirmation code sent to $destination');
      } else {
        print('Update completed');
        Future.delayed(
            loadingTimes,
            () => {
                  this.onLoading(false),
                  Navigator.pushReplacementNamed(
                      context, ROUTE_NAME_PROFILE_VIEW),
                });
      }
    } on AmplifyException catch (e) {
      print(e.message);
      Future.delayed(
          loadingTimes,
          () => {
                this.onLoading(false),
                // Navigator.pop(context),
              });
    }
    ;
  }
}
