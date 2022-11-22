import 'dart:typed_data';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:thecomein/components/custom_surfix_icon.dart';
import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/components/amplify_config.dart';
import 'package:thecomein/helper/comein_api.dart';
import 'package:thecomein/components/message.dart';
import 'package:thecomein/models/user_profile.dart';
import 'package:thecomein/routes.dart';

import 'package:thecomein/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart' show rootBundle;

class ProfileScreen extends StatelessWidget {
  static String routeName = ROUTE_NAME_PROFILE_VIEW;

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfileNavigatorScreen(
      titleText: appMsg(context).my_profile,
    );
  }
}

class ProfilePic extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePic();
  }
}

class _ProfilePic extends State<ProfilePic> {
  //late Uint8List profileData = new Uint8List(0);
  ImageProvider img = AssetImage("assets/images/Profile.png");
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  String _pickImageError = '';

  @override
  void initState() {
    super.initState();
    // loadFile();
    // profileData =
  }

  // loadFile() {
  //   rootBundle.load('assets/images/Profile.png').then((value) => {
  //         setState(() {
  //           Uint8List profileData = value.buffer.asUint8List();
  //           img = MemoryImage(profileData);
  //         })
  //       });
  // }

  loadFile() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    var x = image!.name;
    print('image: $x');
    //var data = image!.readAsBytes();

    //print("data size ");
    // data.then(
    //     ((data) => setState(() => img = MemoryImage(data))));
  }

  @override
  Widget build(BuildContext context) {
    //final ByteData byteData = const AssetImage("assets/images/Profile.png").getByteData();
    return SizedBox(
      height: 200,
      width: 200,
      child: Stack(
        fit: StackFit.expand,
        //  overflow: Overflow.visible,
        children: [
          CircleAvatar(
            // backgroundImage: AssetImage("assets/images/Profile.png"),
            // backgroundImage: MemoryImage(profileData),
            backgroundImage: img,
          ),
          Positioned(
            right: -8,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.white),
                  ),
                  foregroundColor: Color(0xFFF5F6F9),
                ),
                onPressed: () {
                  print('on press->');
                  loadFile();

                  // setState(() {
                  //   img = MemoryImage(data);
                  // });
                },
                child: SvgPicture.asset("assets/icons/Camera.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onImageButtonPressed() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      print('error');
      // setState(() {
      //   _pickImageError = e;
      // });
    }
  }
}

class ProfileNavigatorScreen extends DefaultNavigatorScreen {
  final String titleText;

  const ProfileNavigatorScreen({Key? key, required this.titleText})
      : super(key: key, title: titleText);

  @override
  State<StatefulWidget> createState() {
    return _ProfileNavigatorScreen();
  }
}

class _ProfileNavigatorScreen
    extends DefaultNavigatorScreenState<ProfileNavigatorScreen> {
  //late UserInfo info;
  String firstname = '-';
  String lastname = '-';
  String email = '-';

  fetchUser() async {
    this.onLoading(true);

    // var res = await Amplify.Auth.fetchUserAttributes();
    // UserInfo _info = initProfile(res);
    UserInfo _info = await ComeInAPI.profile();
    print('name=${_info.firstname}');
    setState(() {
      firstname = _info.firstname;
      lastname = _info.lastname;
      email = _info.email;
    });
    Future.delayed(
        loadingTimes,
        () => {
              this.onLoading(false),
            });
  }

  @override
  initState() {
    fetchUser();
    super.initState();
  }

  @override
  Widget buildBody(BuildContext context) {
    // final AppLocalizations appLocale = AppLocalizations.of(context)!;
    var appLocale = appMsg(context);
    return Column(
      children: [
        ProfilePic(),
        SizedBox(height: SizeConfig.screenHeight * 0.05),
        ListTile(
          leading: CustomSurffixIcon(
            svgIcon: "assets/icons/Mail.svg",
            svgSize: 28.0,
            paddingL: 0.0,
            paddingR: 0.0,
            paddingT: 10.0,
            paddingB: 10.0,
          ),
          subtitle: Text(appLocale.email),
          title: Text(email),
        ),
        ListTile(
          leading: CustomSurffixIcon(
            svgIcon: "assets/icons/User.svg",
            svgSize: 28.0,
            paddingL: 0.0,
            paddingR: 0.0,
            paddingT: 10.0,
            paddingB: 10.0,
          ),
          subtitle: Text(appLocale.first_name),
          title: Text(
            firstname,
          ),
          trailing: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, ROUTE_NAME_PROFILE_EDIT,
                    arguments: {
                      "attr_id": CognitoUserAttributeKey.givenName,
                      "attr_name": appLocale.first_name,
                      "attr_value": firstname
                    });
              },
              icon: Icon(Icons.edit)),
        ),
        ListTile(
          leading: CustomSurffixIcon(
            svgIcon: "assets/icons/User.svg",
            svgSize: 28.0,
            paddingL: 0.0,
            paddingR: 0.0,
            paddingT: 10.0,
            paddingB: 10.0,
          ),
          subtitle: Text(appLocale.last_name),
          title: Text(lastname),
          trailing: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, ROUTE_NAME_PROFILE_EDIT,
                    arguments: {
                      "attr_id": CognitoUserAttributeKey.familyName,
                      "attr_name": appLocale.last_name,
                      "attr_value": lastname
                    });
              },
              icon: Icon(Icons.edit)),
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.05),
        DefaultButton(
            text: appLocale.logout,
            press: () {
              doLogout(appLocale.logout_confirm);
            }),
      ],
    );
  }

  doLogout(String message) {
    ConfirmAlert(
      context: context,
      message: message,
      onOK: () async => {
        print('onOK'),
        onLoading(true),
        Navigator.pop(context),
        await Amplify.Auth.signOut(),
        Future.delayed(
            loadingTimes,
            () => {
                  onLoading(false),
                  Navigator.pushNamed(context, ROUTE_NAME_SIGNIN),
                }),
      },
    );
  }
}
