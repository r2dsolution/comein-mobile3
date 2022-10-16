import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:thecomein/components/coustom_bottom_nav_bar.dart';
import 'package:thecomein/components/custom_surfix_icon.dart';
import 'package:thecomein/components/message.dart';
import 'package:thecomein/constants.dart';
import 'package:thecomein/components/amplify_config.dart';
import 'package:thecomein/routes.dart';

import 'package:thecomein/screens/signin_screen.dart';
import 'package:thecomein/size_config.dart';
import 'package:thecomein/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/country.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

typedef OnLoadingCallback = void Function(bool);
typedef ExecuteLoadingCallback = void Function(LoadingEvent);

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    required this.text,
    required this.press,
    this.enable = true,
  }) : super(key: key);
  final String text;
  final Function() press;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: kPrimaryColor,
        onPressed: enable ? press : null,
        child: Text(
          text,
          style: TextStyle(
            fontSize: getFontSize(18),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class DefaultPhoneFeild extends StatelessWidget {
  final Function(String?)? saveEvent;
  final Function(String?)? changeEvent;
  final String? Function(String?)? validateEvent;
  final TextEditingController textController;
  final String textLabel;
  final String hintLabel;
  //final TextInputType inputType;
  final String svgIcon;
  final double fontSize;
  final bool isPassword;
  final Country phoneCountry;
  final Function(Country) countryEvent;

  DefaultPhoneFeild(
      {Key? key,
      this.saveEvent,
      this.changeEvent,
      this.validateEvent,
      required this.textController,
      // this.inputType = TextInputType.text,
      this.isPassword = false,
      required this.phoneCountry,
      required this.countryEvent,
      this.fontSize = 18.0,
      required this.svgIcon,
      required this.hintLabel,
      required this.textLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final font_size = getLabelFontSize(fontSize);

    return TextFormField(
      style: TextStyle(color: kTextPrimaryColor),
      keyboardType: TextInputType.phone,
      controller: textController,
      obscureText: isPassword,
      // onSaved: (newValue) => email = newValue!,
      onSaved: saveEvent,
      onChanged: changeEvent,
      validator: validateEvent,

      decoration: InputDecoration(
        //focusColor: Colors.white,
        //fillColor: Colors.yellow,

        labelText: textLabel,
        labelStyle: labelInputStyle(font_size),
        contentPadding: contenPaddingInputStyle(30, getPaddingVertical(10)),
        hintText: hintLabel,
        helperText: ' ',
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        // floatingLabelStyle: TextStyle(backgroundColor: Colors.red),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: svgIcon),
        prefix: Container(
          // color: Colors.red,
          width: 105,
          height: 40,
          child: ListTile(
            // onTap: () => showDialog(
            //   context: context,
            //   builder: (context) => Theme(
            //       data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            //       child: CountryPickerDialog(
            //           titlePadding: EdgeInsets.all(8.0),
            //           searchCursorColor: Colors.pinkAccent,
            //           searchInputDecoration:
            //               InputDecoration(hintText: 'Search...'),
            //           isSearchable: true,
            //           title: Text('Select your phone code'),
            //           onValuePicked: countryEvent,
            //           // onValuePicked: (Country country) =>
            //           //     setState(() => phneCountry = country),
            //           itemFilter: (c) => ['TH'].contains(c.isoCode),
            //           // priorityList: [
            //           //   CountryPickerUtils.getCountryByIsoCode('TR'),
            //           //   CountryPickerUtils.getCountryByIsoCode('US'),
            //           // ],
            //           itemBuilder: _buildDialogItem)),
            // ),
            title: _buildSelectDialogItem(phoneCountry),
          ),
        ),

        // prefix:
      ),
    );
  }

  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          Text("+${country.phoneCode}"),
          SizedBox(width: 8.0),
          Flexible(child: Text(country.name))
        ],
      );
  Widget _buildSelectDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          Text("+${country.phoneCode}"),
          //SizedBox(width: 8.0),
          // Flexible(child: Text(country.name))
        ],
      );
}

class DefaultTextFeild extends StatelessWidget {
  final Function(String?)? saveEvent;
  final Function(String?)? changeEvent;
  final String? Function(String?)? validateEvent;
  final TextEditingController textController;
  final String textLabel;
  final String hintLabel;
  final TextInputType inputType;
  final String svgIcon;
  final double fontSize;
  final bool isPassword;
  final bool isReadOnly;
  //final String initText;

  const DefaultTextFeild(
      {Key? key,
      this.saveEvent,
      this.changeEvent,
      this.validateEvent,
      required this.textController,
      this.inputType = TextInputType.text,
      // this.initText = '',
      this.isPassword = false,
      this.isReadOnly = false,
      this.fontSize = 18.0,
      required this.svgIcon,
      required this.hintLabel,
      required this.textLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final font_size = getLabelFontSize(this.fontSize);

    return TextFormField(
      // initialValue: initText,
      readOnly: isReadOnly,
      style: TextStyle(color: kTextPrimaryColor),
      keyboardType: inputType,
      controller: textController,
      obscureText: isPassword,
      // onSaved: (newValue) => email = newValue!,
      onSaved: saveEvent,
      onChanged: changeEvent,
      validator: validateEvent,

      decoration: InputDecoration(
        //focusColor: Colors.white,
        //fillColor: Colors.yellow,
        labelText: textLabel,
        labelStyle: labelInputStyle(font_size),
        contentPadding: contenPaddingWidthInputStyle(getPaddingVertical(10)),
        hintText: hintLabel,
        helperText: ' ',
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: svgIcon),
      ),
    );
  }
}

class DefaultPasswordFeild extends StatelessWidget {
  final Function(String?)? saveEvent;
  final Function(String?)? changeEvent;
  final String? Function(String?)? validateEvent;
  final TextEditingController textController;
  final String textLabel;
  final String hintLabel;
  final TextInputType inputType;
  final String svgIcon;
  final double fontSize;

  const DefaultPasswordFeild(
      {Key? key,
      this.saveEvent,
      this.changeEvent,
      this.validateEvent,
      required this.textController,
      this.inputType = TextInputType.text,
      this.fontSize = 18.0,
      required this.svgIcon,
      required this.hintLabel,
      required this.textLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextFeild(
        textController: textController,
        isPassword: true,
        changeEvent: changeEvent,
        validateEvent: validateEvent,
        svgIcon: svgIcon,
        hintLabel: hintLabel,
        textLabel: textLabel);
  }
}

class DefaultBody extends StatelessWidget {
  final bool isLoading;
  final Widget body;

  const DefaultBody({Key? key, required this.isLoading, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayPro(
      isLoading: isLoading,
      progressIndicator: CupertinoActivityIndicator(radius: 100),
      child: Scaffold(
        appBar: AppBar(
          title: Text(" ", style: Theme.of(context).textTheme.headline6),
        ),
        body: body,
      ),
    );
  }
}

const Duration loadingTimes = Duration(seconds: 3);

abstract class DefaultScreen<T extends StatefulWidget> extends State<T> {
  //final String title;
  bool isLoading = false;

  //DefaultScreen({required this.title});

  void onLoading(bool value) {
    print("onLoading....$value");
    setState(() {
      isLoading = value;
    });
  }

  // LoadingEvent initEvent(Function() e) {
  //   return LoadingEvent.initEvent(e, onLoading);
  // }

  // execute(LoadingEvent e) {
  //   print('start to execute');
  //   e.executeEvent();
  // }

  @override
  Widget build(BuildContext context) {
    ComeInAmplifyConfig().init(context);
    //final AppLocalizations appLocale = AppLocalizations.of(context)!;
    var appLocale = appMsg(context);
    return LoadingOverlayPro(
      isLoading: isLoading,
      progressIndicator: CupertinoActivityIndicator(radius: 100),
      // overLoading: Text("Loading...",
      //     style: TextStyle(color: Colors.black, fontSize: 20.0)),
      child: Scaffold(
        appBar: appbar(
          context,
        ),
        body:
            // Body(
            //   onLoad: (_value) => onLoading(_value),

            // ),
            widgetBody(context, onLoading),
      ),
    );
  }

  Widget widgetBody(BuildContext context, OnLoadingCallback loading);
  String screenTitle(
    BuildContext context,
  ) {
    return '';
  }

  Widget appbarTitle(
    BuildContext context,
  ) {
    return Text(screenTitle(context),
        style: Theme.of(context).textTheme.headline6);
  }

  List<Widget>? appbarAction() {
    return null;
  }

  Widget? appbarLeading() {
    return null;
  }

  PreferredSizeWidget appbar(
    BuildContext context,
  ) {
    return AppBar(
      leading: appbarLeading(),
      toolbarHeight: SizeConfig.appBarHeight,
      title: appbarTitle(context),
      actions: appbarAction(),
    );
  }
}

class DefaultUserAppbar extends AppBar {
  final bool isLeading;
  final String titleText;
  final Widget? leading;

  DefaultUserAppbar(
      {this.isLeading = false, required this.titleText, this.leading = null});

  // const DefaultUserAppbar(
  //     {Key? key, this.isLeading = false, required this.titleText})
  //     : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('leading $isLeading');
    return AppBar(
      leading: isLeading ? leading : SizedBox(),
      toolbarHeight: SizeConfig.appBarHeight,
      title: Text(titleText, style: Theme.of(context).textTheme.headline6),
    );
  }
}

class LoadingEvent {
  final int sec;
  late Duration duration; // = Duration(seconds: 3);
  final Function() event;
  final OnLoadingCallback loadingCallback;
  LoadingEvent({
    required this.event,
    required this.loadingCallback,
    this.sec = 3,
  });

  executeEvent() {
    duration = Duration(seconds: sec);
    loadingCallback(true);
    print('start-> execute-event-by delayed');
    //Function.apply(event,null);
    Future.delayed(duration, () => {event, loadingCallback(false)});
    print('end-> execute-event-by delayed');
  }

  static LoadingEvent initEvent(Function() e, OnLoadingCallback callback) {
    LoadingEvent event = new LoadingEvent(event: e, loadingCallback: callback);
    return event;
  }
}

class DefaultTopicText extends StatelessWidget {
  final String label;
  final String subLabel;

  const DefaultTopicText(
      {Key? key, required this.label, required this.subLabel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double fontSizeText1 = getFontSize(18);
    return Column(children: [
      Text(
        label,
        style: Theme.of(context).textTheme.headline4,
      ),
      Text(
        subLabel,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: fontSizeText1),
      )
    ]);
  }
}

ErrorAlert(BuildContext context, String message) {
  //final AppLocalizations appLocale = AppLocalizations.of(context)!;
  var appLocale = appMsg(context);
  var okText = appLocale.ok;
  Alert(
    context: context,
    type: AlertType.error,
    // title: "RFLUTTER ALERT",
    desc: message,
    buttons: [
      DialogButton(
        child: Text(
          okText,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ],
  ).show();
}

YesNoAlert(
    {required BuildContext context,
    required String message,
    required Function() onYES,
    required Function() onNO}) {
  //final AppLocalizations appLocale = AppLocalizations.of(context)!;
  var appLocale = appMsg(context);
  var okText = appLocale.ok;
  Alert(
    context: context,
    type: AlertType.info,
    // title: "RFLUTTER ALERT",
    desc: message,
    buttons: [
      DialogButton(
        child: Text(
          okText,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: onYES,
        width: 120,
      ),
      DialogButton(
        child: Text(
          appLocale.cancel,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: onNO,
        width: 120,
      )
    ],
  ).show();
}

ConfirmAlert(
    {required BuildContext context,
    required String message,
    required Function() onOK}) {
  // final AppLocalizations appLocale = AppLocalizations.of(context)!;
  var appLocale = appMsg(context);
  var okText = appLocale.ok;
  Alert(
    context: context,
    type: AlertType.info,
    // title: "RFLUTTER ALERT",
    desc: message,
    buttons: [
      DialogButton(
        child: Text(
          okText,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: onOK,
        width: 120,
      ),
      DialogButton(
        child: Text(
          appLocale.cancel,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ],
  ).show();
}

InputAlert(
    {required BuildContext context,
    required TextEditingController inputController,
    String valueText = '',
    String titleText = 'Please input',
    String labelText = 'Input',
    String labelButton = 'Submit',
    Widget iconText = const Icon(Icons.account_circle),
    required Function() onSubmit}) {
  inputController.text = valueText;
  Alert(
      context: context,
      title: titleText,
      content: Column(
        children: <Widget>[
          TextField(
            controller: inputController,
            decoration: InputDecoration(
              icon: iconText,
              labelText: labelText,
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          //  onPressed: () => Navigator.pop(context),
          onPressed: onSubmit,
          child: Text(
            labelButton,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]).show();
}

SuccessAlert(BuildContext context, String message, Function() onOK) {
  //final AppLocalizations appLocale = AppLocalizations.of(context)!;
  var appLocale = appMsg(context);
  var okText = appLocale.ok;
  Alert(
    //closeFunction: onClose,
    context: context,
    type: AlertType.success,
    // title: "RFLUTTER ALERT",
    desc: message,
    buttons: [
      DialogButton(
        child: Text(
          okText,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: onOK,
        width: 120,
      )
    ],
  ).show();
}

abstract class DefaultNavigatorScreen extends StatefulWidget {
//   // final Widget body;
  final String title;
//   //Function(bool) loading;

  const DefaultNavigatorScreen({Key? key, required this.title})
      : super(key: key);
}

abstract class DefaultNavigatorScreenState<T extends DefaultNavigatorScreen>
    extends State<T> {
  bool isLoading = false;
  void onLoading(bool value) {
    print("onLoading....$value");
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    ComeInAmplifyConfig().init(context);
    //final AppLocalizations appLocale = AppLocalizations.of(context)!;
    return LoadingOverlayPro(
      isLoading: isLoading,
      progressIndicator: CupertinoActivityIndicator(radius: 100),
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title, style: TextStyle(color: Colors.black)),
            toolbarHeight: SizeConfig.appBarHeight,
          ),
          body: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: SingleChildScrollView(
                child: Column(children: [
                  // Text(widget.title,
                  //     style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: SizeConfig.screenHeight * 0.005),
                  buildBody(context),
                ]),
              ),
            ),
          )
          // bottomNavigationBar:
          //     CustomBottomNavBar(selectedMenu: MenuState.hotelBooking),
          ),
    );
  }

  Widget buildBody(BuildContext context);
}

abstract class DefaultUserScreen extends StatefulWidget {
  //final PreferredSizeWidget appbar;

  final String title;
  final Widget? titleWidget;
  final MenuState menu;

  const DefaultUserScreen(
      {Key? key, required this.title, this.titleWidget, required this.menu})
      : super(key: key);
}

abstract class DefaultUserScreenState<T extends DefaultUserScreen>
    extends State<T> {
  bool isLoading = false;
  GlobalKey _keyMenu = GlobalKey();
  Offset? tapPos;

  void onLoading(bool value) {
    print("onLoading....$value");
    setState(() {
      isLoading = value;
    });
  }

  PreferredSizeWidget initAppbar(String _title) {
    // final AppLocalizations appLocale = AppLocalizations.of(context)!;
    var appLocale = appMsg(context);
    print('screen title: $_title');
    // List<PopupMenuItemBean> menuList = [];
    // List<Map<String, String>> menuListData = [
    //   {"title": "My Profile", "id": "profile", "icon": "assets/icons/User.svg"},
    //   {"title": "Logout", "id": "logout", "icon": "assets/icons/Lock.svg"}
    // ];
    // menuListData.forEach((Map item) {
    //   PopupMenuItemBean bottomItem = PopupMenuItemBean();
    //   bottomItem.title = item["title"];
    //   bottomItem.id = item["id"];
    //   bottomItem.icon = item["icon"];
    //   menuList.add(bottomItem);
    // });
    return AppBar(
      leading: SizedBox(),
      toolbarHeight: SizeConfig.appBarHeight,
      //title: Text('', style: Theme.of(context).textTheme.headline6),
      // title:  Text("tawatchr0009@gmail.com", style: TextStyle(color: Colors.black)),
      actions: [
        PopupMenuButton(
          child: Icon(
            Icons.account_circle,
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: ListTile(
                title:
                    Text(appLocale.my_profile, style: TextStyle(fontSize: 15)),
                trailing: Icon(Icons.account_box),
                // onTap: () =>
                //     Navigator.pushNamed(context, ProfileScreen.routeName),
              ),
              value: 1,
            ),
            PopupMenuItem(
              child: ListTile(
                title: Text(appLocale.profile_change_password,
                    style: TextStyle(fontSize: 15)),
                trailing: Icon(Icons.lock),
              ),
              value: 2,
            ),
            PopupMenuItem(
              child: ListTile(
                title: Text(appLocale.logout, style: TextStyle(fontSize: 15)),
                trailing: Icon(Icons.lock_open),
                // onTap: () => {
                //   ConfirmAlert(
                //     context: context,
                //     message: 'Logout ?',
                //     onOK: () async => {
                //       print('onOK'),
                //       onLoading(true),
                //       Navigator.pop(context),
                //       await Amplify.Auth.signOut(),
                //       Future.delayed(
                //           loadingTimes,
                //           () => {
                //                 onLoading(false),
                //                 Navigator.pushNamed(
                //                     context, SignInScreen.routeName),
                //               }),
                //     },
                //   ),
                // },
              ),
              value: 3,
            )
          ],
          onSelected: (index) {
            switch (index) {
              case 1:
                Navigator.pushNamed(context, ROUTE_NAME_PROFILE_VIEW);
                break;
              case 2:
                Navigator.pushNamed(context, ROUTE_NAME_PASSWORD_CHANGE);
                break;
              case 3:
                ConfirmAlert(
                  context: context,
                  message: appLocale.logout_confirm,
                  onOK: () async => {
                    print('onOK'),
                    onLoading(true),
                    Navigator.pop(context),
                    await Amplify.Auth.signOut(),
                    Future.delayed(
                        loadingTimes,
                        () => {
                              onLoading(false),
                              Navigator.pushNamed(
                                  context, SignInScreen.routeName),
                            }),
                  },
                );
                break;
            }
          },
        ),
        // IconButton(
        //     onPressed: () {},
        //     icon: Text("tawatchr0009@gmail.com",
        //         style: TextStyle(color: Colors.black))),
        // GestureDetector(
        //   onTapDown: (TapDownDetails details) {
        //     tapPos = details.globalPosition;
        //   },
        //   child: IconButton(
        //     key: _keyMenu,
        //     icon: Icon(
        //       Icons.account_circle,
        //     ),
        //     onPressed: () {
        //       // PopupMenuUtils.popupPositioned(
        //       //   context: context,
        //       //   topList: menuList,
        //       //   //bottomList: bottomList,
        //       //   tapPos: tapPos,
        //       //   onSelected: (PopupMenuItemBean item) {
        //       //     print(item.title);
        //       //   },
        //       // );
        //     },
        //   ),
        // ),
        // IconButton(
        //   icon: Row(
        //     children: [Icon(Icons.logout_outlined)],
        //   ),
        //   onPressed: () {
        //     // Navigator.pushNamed(context, SignInScreen.routeName),
        //     // Navigator.pushNamed(context, SignInScreen.routeName),
        //     ConfirmAlert(
        //       context: context,
        //       message: 'Logout ?',
        //       onOK: () async => {
        //         print('onOK'),
        //         onLoading(true),
        //         Navigator.pop(context),
        //         await Amplify.Auth.signOut(),
        //         Future.delayed(
        //             loadingTimes,
        //             () => {
        //                   onLoading(false),
        //                   Navigator.pushNamed(context, SignInScreen.routeName),
        //                 }),
        //       },
        //     );
        //   },
        // ),
        // Text(
        //   "Logout",
        //   style: TextStyle(color: Colors.black),
        // ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('init DefaultUserScreen');
    print('menu->' + widget.menu.toString());
    ComeInAmplifyConfig().init(context);
    // final AppLocalizations appLocale = AppLocalizations.of(context)!;
    return LoadingOverlayPro(
      isLoading: isLoading,
      progressIndicator: CupertinoActivityIndicator(radius: 100),
      child: Scaffold(
        appBar: initAppbar(widget.title),
        body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(children: [
                    (widget.titleWidget == null)
                        ? Text(widget.title,
                            style: Theme.of(context).textTheme.headline6)
                        : widget.titleWidget!,
                    // SizedBox(height: SizeConfig.screenHeight * 0.02),
                    //widget.body,
                    buildBody(context),
                  ]),
                ),
                searchBody(context),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(selectedMenu: widget.menu),
      ),
    );
  }

  Widget buildBody(BuildContext context);
  Widget searchBody(BuildContext context);
}

class EmailTextFeild extends StatelessWidget {
  //late String emailLabel;
  final Function(String?)? saveEvent;
  final Function(String?)? changeEvent;
  final String? Function(String?)? validateEvent;
  final TextEditingController textController;

  const EmailTextFeild(
      {Key? key,
      this.saveEvent,
      this.changeEvent,
      this.validateEvent,
      required this.textController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final AppLocalizations? appLocale = AppLocalizations.of(context);
    var appLocale = appMsg(context);
    final String emailLabel = appLocale!.email;
    final String emailHintLabel = appLocale.email_hint;
    final font_size = getLabelFontSize(18);
    print('email font-size: $font_size');
    return TextFormField(
      style: TextStyle(color: kTextPrimaryColor),
      keyboardType: TextInputType.emailAddress,
      controller: textController,
      // onSaved: (newValue) => email = newValue!,
      onSaved: saveEvent,
      onChanged: changeEvent,
      validator: validateEvent,
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(error: kEmailNullError);
      //   } else if (emailValidatorRegExp.hasMatch(value)) {
      //     removeError(error: kInvalidEmailError);
      //   }
      // },
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     addError(error: kEmailNullError);
      //     return "";
      //   } else if (!emailValidatorRegExp.hasMatch(value)) {
      //     addError(error: kInvalidEmailError);
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        //focusColor: Colors.white,
        //fillColor: Colors.yellow,
        labelText: emailLabel,
        labelStyle: labelInputStyle(font_size),
        contentPadding: contenPaddingWidthInputStyle(getPaddingVertical(10)),
        hintText: emailHintLabel,
        helperText: ' ',
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
