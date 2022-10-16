import 'dart:collection';
import 'dart:typed_data';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:thecomein/components/default_ui.dart';
import 'package:thecomein/routes.dart';
import 'package:thecomein/size_config.dart';
import 'package:flutter/material.dart';

class LunchingPageScreen extends StatefulWidget {
  static String routeName = ROUTE_NAME_LUNCHING_PAGE;

  const LunchingPageScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LunchingPageScreen();
  }
}

class _LunchingPageScreen extends DefaultScreen<LunchingPageScreen> {
  doInitScreen(BuildContext context) {
    Future.delayed(
      loadingTimes,
      () => {
        Navigator.pushReplacementNamed(context, ROUTE_NAME_MAIN_BOOKING),
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => doInitScreen(context));
  }

  @override
  Widget widgetBody(BuildContext context, OnLoadingCallback loading) {
    return Body(
      loading: onLoading,
    );
  }

  @override
  Widget? appbarLeading() {
    return SizedBox();
  }
}

class Body extends StatelessWidget {
  final OnLoadingCallback loading;

  const Body({Key? key, required this.loading}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Image.asset(
          "assets/images/success.png",
          height: SizeConfig.screenHeight * 0.4, //40%
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.08),
        Text(
          "Login Success",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(30),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Spacer(),
        // SizedBox(
        //   width: SizeConfig.screenWidth * 0.6,
        //   child: DefaultButton(
        //     text: "Back to home",
        //     press: () async {
        //       loading(true);
        //       // SignOutResult res = await Amplify.Auth.signOut();
        //       Future.delayed(
        //         loadingTimes,
        //         () => {
        //           loading(false),
        //           // Navigator.pushNamed(context, SignInScreen.routeName),
        //           // doLambdaLogin('test1', 'test2'),
        //           Navigator.pushNamed(context, ROUTE_NAME_HOTEL_BOOKING),
        //           //  Navigator.pushNamed(context, CardIDCameraOverlay.routeName),
        //         },
        //       );

        //       // Navigator.pushNamed(context, HotelBookingScreen.routeName);
        //     },
        //   ),
        // ),
        // Spacer(),
      ],
    );
  }

  doLambdaLogin(String _firstname, String _lastname) async {
    try {
      AuthSession session = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );
      //AuthSession session = await Amplify.Auth.fetchAuthSession();
      CognitoAuthSession cognitoSession = session as CognitoAuthSession;
      AuthUser user = await Amplify.Auth.getCurrentUser();

      //String identityId = (res as CognitoAuthSession);
      //  print('identityId: $identityId');
      // String sessionToken = res.userPoolTokens.idToken.
      //bool isSign = cognitoSession.isSignedIn;
      //cognitoSession.identityId;
      //print('user is sign-in:${isSign}');
      //String sessionToken = session.identityId!;
      // String token = cognitoSession.identityId!;
      String token = session.userPoolTokens!.idToken;

      print('xxxxx');
      print('hello lambda - mail - send -sayHello -${token}-');
      print('xxxxx');

      Map<String, String> headers = {"comein_auth": token};

      // List<int> data =
      //     '{"firstName":"${_firstname}", "lastName":"${_lastname}"}'.codeUnits;
      List<int> data = '{"email":"test1@gmail.com"}'.codeUnits;
      RestOptions options = RestOptions(
          apiName: 'comein-mobile',
          path: '/hotel-bookings',
          body: Uint8List.fromList(data),
          headers: {'comein_auth': token});
      //print(options.);
      RestOperation restOperation = Amplify.API.post(restOptions: options);
      RestResponse response = await restOperation.response;
      print('POST call succeeded');
      print(new String.fromCharCodes(response.data));
    } on ApiException catch (e) {
      print('POST call failed: $e');
    }
  }
}
