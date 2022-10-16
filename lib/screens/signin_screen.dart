import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:thecomein/components/custom_surfix_icon.dart';
import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/components/form_error.dart';
import 'package:thecomein/components/locale_provider.dart';
import 'package:thecomein/components/space_box.dart';
import 'package:thecomein/components/social_card.dart';
import 'package:thecomein/constants.dart';
import 'package:thecomein/components/amplify_config.dart';
import 'package:thecomein/helper/comein_api.dart';

import 'package:thecomein/components/message.dart';
import 'package:thecomein/models/user_profile.dart';
import 'package:thecomein/routes.dart';
import 'package:thecomein/size_config.dart';
import 'package:thecomein/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
//import 'package:package_info_plus/package_info_plus.dart';

typedef OnLoadEvent = void Function(LoadingEvent);

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
    print('execute-event-by delayed');
    //Function.apply(event,null);
    Future.delayed(duration, () => {event, loadingCallback(false)});
  }
}

class SignInScreen extends StatefulWidget {
  static const String routeName = ROUTE_NAME_SIGNIN;

  const SignInScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _SignInScreen();
  }
}

class _SignInScreen extends State<SignInScreen> {
  bool _isLoading = false;
  Duration duration = Duration(seconds: 3);
  String version = "";
  String buildNo = "";

  void _onLoading(bool value) {
    print("onLoading....$value");
    setState(() {
      _isLoading = value;
    });

    // Future.delayed(duration, () {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
  }

  // void _LoadingEvent(Function() e) {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   Future.delayed(duration, e);
  // }

  @override
  void initState() {
    print('before init-state......');
    ComeInAmplifyConfig().init(context);
    super.initState();

    print('after init-state......');
    WidgetsBinding.instance!.addPostFrameCallback((_) => doInitScreen(context));
  }

  doInitScreen(BuildContext c) async {
    print('after page-load');
    _onLoading(true);
    // AmplifyConfig().init(context);

    Future.delayed(
      loadingTimes,
      () async => {
        await Amplify.Auth.signOut(),
        print('sign-out completed'),
        _onLoading(false),
        print('load..init finish'),
      },
    );
  }

// class SignInScreen extends StatelessWidget {
//   static String routeName = "/sign_in";
  @override
  Widget build(BuildContext context) {
    print('init sign-in');

    SizeConfig().init(context);
    double h_screen = SizeConfig.screenHeight;
    double icon_size = SizeConfig.appBarHeight;

    print('screen height: $h_screen');
    return Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
      bool isTH = provider.isTH;

      return LoadingOverlayPro(
        progressIndicator: CupertinoActivityIndicator(radius: 100),
        isLoading: _isLoading,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: SizeConfig.appBarHeight,
            //backgroundColor: Colors.red,
            leading: SizedBox(),
            title: Text(
              "",
              style: Theme.of(context).textTheme.headline6,
            ),
            actions: [
              AnimatedToggleSwitch<bool>.size(
                  current: isTH,
                  values: [true, false],
                  iconOpacity: 0.2,
                  // height: 1,
                  height: icon_size,
                  // iconSize: Size.square(300),
                  indicatorSize: Size.square(icon_size),
                  // indicatorType: IndicatorType.roundedRectangle,
                  iconAnimationType: AnimationType.onHover,
                  indicatorAnimationType: AnimationType.onHover,
                  // iconBuilder: (i, size, active) {
                  //   IconData data = Icons.access_time_rounded;
                  //   //if (i.isEven) data = Icons.cancel;
                  //   return Container(
                  //       child: Icon(
                  //     data,
                  //     size: min(size.width, size.height),
                  //   ));
                  // },
                  // iconBuilder: (b, size, active) => b
                  //     ? SvgPicture.asset('icons/flags/svg/us.svg',
                  //         package: 'country_icons')
                  //     //: Icon(Icons.tag_faces_rounded),
                  //     : SvgPicture.asset('icons/flags/svg/th.svg',
                  //         package: 'country_icons'),
                  iconBuilder: (i, size, active) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        localeTextBuilder(i, Size.square(icon_size), active),
                        //alternativeIconBuilder(i, size, active),
                      ],
                    );
                  },
                  //  iconSize: ,
                  borderWidth: 1,
                  borderRadius: BorderRadius.zero,
                  borderColor: Colors.black,
                  colorBuilder: (i) => Colors.amber,
                  onChanged: (i) => i
                      ? provider.setLocale(Locale("th", "TH"))
                      : provider.setLocale(Locale("en"))),
              SizedBox(
                width: 20,
              )
            ],
          ),
          body: Body(
            onLoad: (_value) => this._onLoading(_value),
          ),
          // body: LoadingOverlayPro(
          //   isLoading: _isLoading,
          //   child: ElevatedButton(
          //     onPressed: () {
          //       _submit();
          //     },
          //     child: Text('Show Loading BouncingLine'),
          //   ),
          // ),
        ),
      );
    });
  }
}

Widget localeTextBuilder(bool i, Size size, bool active) {
  double font_size = getFontSize(18);
  print('font size: $font_size');
  if (i) {
    return Text(
      "TH",
      style: TextStyle(
          color: Colors.black,
          fontSize: font_size,
          fontWeight: FontWeight.bold),
    );
  } else {
    return Text(
      "EN",
      style: TextStyle(
          color: Colors.black,
          fontSize: font_size,
          fontWeight: FontWeight.bold),
    );
  }
}

class Body extends StatefulWidget {
  //final bool isLoading;
  final OnLoadingCallback onLoad;

  const Body({Key? key, required this.onLoad}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return BodyState();
  }
}

class BodyState extends State<Body> {
  late UserAccount loginUser;
  // Duration duration = Duration(seconds: 3);

  // void _submit() {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   Future.delayed(duration, () {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  // }

//class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    //final AppLocalizations? appLocale = AppLocalizations.of(context);
    var appLocale = appMsg(context);
    final String loginTextLabel = appLocale!.login_text1;
    final double fontSizeText1 = getFontSize(18);
    print('text1-fontsize=$fontSizeText1');
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //SpaceBox(height: 10.0),
                // Text(
                //   "Come In",
                //   textAlign: TextAlign.center,
                //   style: TextStyle(color: Colors.red),
                // ),
                Image.asset(
                  'assets/images/comein_logo.png',
                  height: getScreenHeight(0.25),
                ),
                SpaceBox(height: 2.0),
                Text(
                  loginTextLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: fontSizeText1),
                ),
                SpaceBox(height: 5.0),

                SignForm(
                  // onSubmit: () => _submit(),
                  onLoad: widget.onLoad,
                  onLogin: doLogin,
                ),
                SpaceBox(height: 2.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialCard(
                      icon: "assets/icons/google-icon.svg",
                      press: () {},
                    ),
                    SocialCard(
                      icon: "assets/icons/facebook-2.svg",
                      press: () {},
                    ),
                    SocialCard(
                      icon: "assets/icons/twitter.svg",
                      press: () {},
                    ),
                  ],
                ),
                SpaceBox(height: 2.0),
                NoAccountText(),
                SpaceBox(height: 1.0),
                VersionText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  doLogin(String _username, String _password) async {
    widget.onLoad(true);
    print('start to login process...');
    try {
      SignInResult res = await Amplify.Auth.signIn(
        username: _username,
        password: _password,
      );

      if (res.isSignedIn) {
        print('Login success');
        // var res = await Amplify.Auth.fetchUserAttributes();
        // UserInfo p = initProfile(res);
        UserInfo p = await ComeInAPI.profile();
        Future.delayed(
          loadingTimes,
          () => {
            widget.onLoad(false),
            Navigator.pushNamed(context, ROUTE_NAME_LUNCHING_PAGE,
                arguments: p),
          },
        );
      } else {
        print('Login fail');
      }
    } on AuthException catch (e) {
      var error = e.message;
      print('auth-exception= $error');
      var resText = messages(context, error);
      Future.delayed(
        loadingTimes,
        () => {widget.onLoad(false), ErrorAlert(context, resText)},
      );
    }
  }
}

class SignForm extends StatefulWidget {
  // final Function() onSubmit;
  final OnLoadingCallback onLoad;
  final Function(String, String) onLogin;

  const SignForm({Key? key, required this.onLoad, required this.onLogin})
      : super(key: key);
  @override
  _SignFormState createState() => _SignFormState(onLoad);
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  bool isTH = true;
  int value = 0;

  late String password;
  bool remember = false;
  final List<String> errors = [];
  bool isSignedIn = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // final Function() onSubmitForm;
  final OnLoadingCallback onLoad;
  Duration duration = Duration(seconds: 3);

  _SignFormState(this.onLoad);

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

  doChangeEmail(String? email) {
    //print('doChangeEmail -> email= $email');
    if (email!.isNotEmpty) {
      removeError(error: kEmailNullError);
    } else if (emailValidatorRegExp.hasMatch(email)) {
      removeError(error: kInvalidEmailError);
    }
  }

  String? doValidateEmail(String? email) {
    // print('doValidateEmail -> email= $email');
    if (email!.isEmpty) {
      //print('doValidateEmail -> empty email');
      addError(error: kEmailNullError);
      return '';
    } else if (!emailValidatorRegExp.hasMatch(email)) {
      // print('doValidateEmail ->  email-pattern not match email= $email');
      addError(error: kInvalidEmailError);
      return '';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    //final AppLocalizations? appLocale = AppLocalizations.of(context);
    var appLocale = appMsg(context);
    final String rememberMeLabel = appLocale!.remember_me;
    final String forgotPasswordLabel = appLocale.forgot_password;
    final String nextLabel = appLocale.next;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          //buildEmailFormField(appLocale),
          EmailTextFeild(
            textController: emailController,
            changeEvent: (_email) => doChangeEmail(_email),
            validateEvent: (_email) => doValidateEmail(_email),
          ),
          // SizedBox(height: getProportionateScreenHeight(30)),
          //buildPasswordFormField(appLocale),
          PasswordTextField(textController: passwordController),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value!;
                  });
                },
              ),
              Text(
                rememberMeLabel,
                style: TextStyle(fontSize: getSubFontSize(18)),
              ),
              Spacer(),
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, ROUTE_NAME_PASSWORD_FORGOT),
                //onTap: () => print('hello forgot-password'),
                child: Text(
                  forgotPasswordLabel,
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: getSubFontSize(18)),
                ),
              ),
              SizedBox(
                width: 20,
              )
            ],
          ),
          // SizedBox(height: getScreenHeight(0.005)),
          // AnimatedToggleSwitch<bool>.dual(
          //     current: isTH,
          //     first: true,
          //     second: false,
          //     indicatorSize: Size.fromWidth(100),
          //     indicatorType: IndicatorType.rectangle,
          //     // iconAnimationType: AnimationType.onHover,
          //     indicatorAnimationType: AnimationType.onHover,
          //     onChanged: (b) => setState(() => isTH = b),
          //     //  colorBuilder: (b) => b ? Colors.red : Colors.green,
          //     iconBuilder: (b, size, active) => b
          //         ? SvgPicture.asset('icons/flags/svg/us.svg',
          //             package: 'country_icons')
          //         //: Icon(Icons.tag_faces_rounded),
          //         : SvgPicture.asset('icons/flags/svg/th.svg',
          //             package: 'country_icons')
          //     // textBuilder: (b, size, active) => b
          //     //     ? Center(child: Text('Oh no...'))
          //     //     : Center(child: Text('Nice :)')),
          //     ),
          // AnimatedToggleSwitch<bool>.size(
          //   current: isTH,
          //   values: [true, false],
          //   iconOpacity: 0.2,
          //   indicatorSize: Size.fromWidth(30),
          //   indicatorType: IndicatorType.rectangle,
          //   iconAnimationType: AnimationType.onHover,
          //   indicatorAnimationType: AnimationType.onHover,
          //   // iconBuilder: (i, size, active) {
          //   //   IconData data = Icons.access_time_rounded;
          //   //   //if (i.isEven) data = Icons.cancel;
          //   //   return Container(
          //   //       child: Icon(
          //   //     data,
          //   //     size: min(size.width, size.height),
          //   //   ));
          //   // },
          //   // iconBuilder: (b, size, active) => b
          //   //     ? SvgPicture.asset('icons/flags/svg/us.svg',
          //   //         package: 'country_icons')
          //   //     //: Icon(Icons.tag_faces_rounded),
          //   //     : SvgPicture.asset('icons/flags/svg/th.svg',
          //   //         package: 'country_icons'),
          //   iconBuilder: (i, size, active) {
          //     return Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         alternativeTextBuilder(i, size, active),
          //         //alternativeIconBuilder(i, size, active),
          //       ],
          //     );
          //   },
          //   borderWidth: 0.0,
          //   borderRadius: BorderRadius.zero,
          //   borderColor: Colors.transparent,
          //   colorBuilder: (i) => Colors.amber,
          //   onChanged: (i) => setState(() => isTH = i),
          // ),
          DefaultButton(
            text: nextLabel,
            press: () {
              // onLoad(true);
              clearLogin();
              var email_value = emailController.text;

              var password_value = passwordController.text;

              print('email: $email_value');
              print('password: $password_value');
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // if all are valid then go to success screen
                //KeyboardUtil.hideKeyboard(context);

                //Navigator.pushNamed(context, LoginSuccessScreen.routeName);
                print('hello login-email: $email_value');
                // login(emailController.text, passwordController.text);
                // LoadingEvent _loginEvent = initEvent(
                //     () => login(emailController.text, passwordController.text));
                // _loginEvent.executeEvent();
                widget.onLogin(email_value, password_value);
                setState(() {
                  passwordController.text = '';
                });
              }
              print('start to delay...');
              // Future.delayed(duration, () {
              //   onLoad(false);
              // });
            },
            //press: onSubmitForm,
          ),
        ],
      ),
    );
  }

  LoadingEvent initEvent(Function() e) {
    LoadingEvent event = new LoadingEvent(event: e, loadingCallback: onLoad);
    return event;
  }

  doNextLoginSuccess() {
    Navigator.pushNamed(context, ROUTE_NAME_LUNCHING_PAGE);
  }

  clearLogin() async {
    try {
      print('logout..');
      await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      var error = e.message;
      print('auth-exception= $error');
    }
  }

  // login(String _username, String _password) async {
  //   print('start to login process...');
  //   try {
  //     SignInResult res = await Amplify.Auth.signIn(
  //       username: _username,
  //       password: _password,
  //     );

  //     setState(() {
  //       print('login result=${isSignedIn}');
  //       isSignedIn = res.isSignedIn;
  //       if (isSignedIn) {
  //         doNextLoginSuccess();
  //       } else {
  //         print('Login fail');
  //       }
  //     });
  //   } on AuthException catch (e) {
  //     var error = e.message;
  //     print('auth-exception= $error');
  //   }
  // }

  // TextFormField buildPasswordFormField(AppLocalizations appLocale) {
  //   final String passwordLabel = appLocale.password;
  //   final String passwordHintLabel = appLocale.password_hint;
  //   return TextFormField(
  //     style: TextStyle(color: kTextPrimaryColor),
  //     obscureText: true,
  //     onSaved: (newValue) => password = newValue!,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: kPassNullError);
  //       } else if (value.length >= 8) {
  //         removeError(error: kShortPassError);
  //       }
  //       return null;
  //     },
  //     validator: (value) {
  //       if (value!.isEmpty) {
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
  //       labelStyle: labelInputStyle(getLabelFontSize(18)),
  //       contentPadding: contenPaddingWidthInputStyle(getPaddingVertical(10)),
  //       // If  you are using latest version of flutter then lable text and hint text shown like this
  //       // if you r using flutter less then 1.20.* then maybe this is not working properly
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
  //     ),
  //   );
  // }

  // TextFormField buildEmailFormField(AppLocalizations appLocal) {
  //   final String emailLabel = appLocal.email;
  //   final String emailHintLabel = appLocal.email_hint;
  //   final font_size = getLabelFontSize(18);
  //   print('email font-size: $font_size');
  //   return TextFormField(
  //     style: TextStyle(color: kTextPrimaryColor),
  //     keyboardType: TextInputType.emailAddress,
  //     onSaved: (newValue) => email = newValue!,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: kEmailNullError);
  //       } else if (emailValidatorRegExp.hasMatch(value)) {
  //         removeError(error: kInvalidEmailError);
  //       }
  //     },
  //     validator: (value) {
  //       if (value!.isEmpty) {
  //         addError(error: kEmailNullError);
  //         return "";
  //       } else if (!emailValidatorRegExp.hasMatch(value)) {
  //         addError(error: kInvalidEmailError);
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       //focusColor: Colors.white,
  //       //fillColor: Colors.yellow,
  //       labelText: emailLabel,
  //       labelStyle: labelInputStyle(font_size),
  //       contentPadding: contenPaddingWidthInputStyle(getPaddingVertical(10)),
  //       hintText: emailHintLabel,
  //       helperText: ' ',
  //       // If  you are using latest version of flutter then lable text and hint text shown like this
  //       // if you r using flutter less then 1.20.* then maybe this is not working properly
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
  //     ),
  //   );
  // }
}

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final AppLocalizations? appLocale = AppLocalizations.of(context);
    var appLocale = appMsg(context);
    final String noAccountLabel = appLocale!.no_account_text;
    final String signUpLabel = appLocale.sign_up;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          noAccountLabel,
          style: TextStyle(fontSize: getFontSize(18)),
        ),
        GestureDetector(
          //onTap: () => Navigator.pushNamed(context, SignUpScreen.routeName),
          onTap: () =>
              Navigator.pushNamed(context, ROUTE_NAME_SIGNUP_AGREEMENT),
          //print('hello'),
          child: Text(
            signUpLabel,
            style: TextStyle(fontSize: getFontSize(18), color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}

class PasswordTextField extends StatelessWidget {
  final Function(String?)? saveEvent;
  final Function(String?)? changeEvent;
  final String? Function(String?)? validateEvent;
  final TextEditingController textController;

  const PasswordTextField(
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
    final String passwordLabel = appLocale!.password;
    final String passwordHintLabel = appLocale.password_hint;
    return TextFormField(
      controller: textController,
      style: TextStyle(color: kTextPrimaryColor),
      obscureText: true,
      //onSaved: (newValue) => password = newValue!,
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(error: kPassNullError);
      //   } else if (value.length >= 8) {
      //     removeError(error: kShortPassError);
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value!.isEmpty) {
      //     addError(error: kPassNullError);
      //     return "";
      //   } else if (value.length < 8) {
      //     addError(error: kShortPassError);
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        labelText: passwordLabel,
        hintText: passwordHintLabel,
        labelStyle: labelInputStyle(getLabelFontSize(18)),
        contentPadding: contenPaddingWidthInputStyle(getPaddingVertical(10)),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }
}

class LoadingOverlayPage extends StatefulWidget {
  @override
  _LoadingOverlayPageState createState() => _LoadingOverlayPageState();
}

class _LoadingOverlayPageState extends State<LoadingOverlayPage> {
  late bool _isLoading = false;

  bool _isIOS = false;

  Duration duration = Duration(seconds: 3);

  void _submit() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(duration, () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Loading Overlay'),
          backgroundColor: Colors.blue,
        ),
        body: LoadingOverlayPro(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _isIOS = false;
                    _submit();
                  },
                  child: Text('Show Loading BouncingLine'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _isIOS = true;
                    _submit();
                  },
                  child: Text('Show Loading Custom IOS'),
                ),
              ],
            ),
          ),
          backgroundColor: _isIOS ? Colors.white : Colors.black54,
          isLoading: _isLoading,
          progressIndicator: _isIOS
              ? CupertinoActivityIndicator(radius: 100)
              : LoadingBouncingLine.circle(
                  backgroundColor: Colors.blue,
                  size: 150.0,
                  duration: Duration(seconds: 2),
                  borderColor: Colors.blue,
                ),
          overLoading: _isIOS
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlutterLogo(),
                    SizedBox(width: 10),
                    Text(
                      "Loading Overlay Pro",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                )
              : null,
          bottomLoading: _isIOS
              ? Text("Loading...", style: TextStyle(fontSize: 20.0))
              : null,
        ),
      );

  // Widget test() {
  //   return LoadingOverlayPro(
  //     child: Center(
  //       child: ElevatedButton(
  //         onPressed: () {
  //           _submit();
  //         },
  //         child: Text('Show Loading Custom IOS'),
  //       ),
  //     ),
  //     backgroundColor: _isIOS ? Colors.white : Colors.black54,
  //     isLoading: _isLoading,
  //     progressIndicator: _isIOS
  //         ? CupertinoActivityIndicator(radius: 100)
  //         : LoadingBouncingLine.circle(
  //             backgroundColor: Colors.blue,
  //             size: 150.0,
  //             duration: Duration(seconds: 2),
  //             borderColor: Colors.blue,
  //           ),
  //     overLoading: Text("App Name"),
  //     bottomLoading: Text("Loading..."),
  //   );
  // }
}

class VersionText extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VersionText();
  }
}

class _VersionText extends State<VersionText> {
  String version = "";
  String buildNo = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => doVersionScreen(context));
  }

  doVersionScreen(BuildContext c) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String _version = packageInfo.version;
    String _buildNo = packageInfo.buildNumber;
    setState(() {
      this.version = _version;
      this.buildNo = _buildNo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text("version: ${version} - ${buildNo}.",
        style: TextStyle(fontSize: 10));
  }
}
