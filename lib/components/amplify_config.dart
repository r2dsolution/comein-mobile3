import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:thecomein/amplifyconfiguration.dart';
import 'package:thecomein/helper/logger.dart';
import 'package:flutter/material.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class ComeInAmplifyConfig {
  static late bool isConfig = false;
  void init(BuildContext context) {
    if (!isConfig) {
      _configureAmplify();
    }
    isConfig = true;
  }
}

void _configureAmplify() async {
  // Add Pinpoint and Cognito Plugins, or any other plugins you want to use
  // AmplifyAnalyticsPinpoint analyticsPlugin = AmplifyAnalyticsPinpoint();
  AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
  AmplifyAPI apiPlugin = AmplifyAPI();
  AmplifyStorageS3 s3Plugin = AmplifyStorageS3();
  await Amplify.addPlugins([apiPlugin, authPlugin, s3Plugin]);
  //await Amplify.addPlugins([apiPlugin, authPlugin]);

  // Once Plugins are added, configure Amplify
  // Note: Amplify can only be configured once.
  try {
    await Amplify.configure(amplifyconfig);
  } on AmplifyAlreadyConfiguredException {
    Logger.log(
        "Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
  }
}
