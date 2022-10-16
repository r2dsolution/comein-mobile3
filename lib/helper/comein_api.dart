import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

//import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:thecomein/models/user_confirm.dart';
import 'package:thecomein/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:uuid/uuid.dart';

class ComeInAPI {
  // static String post(String restURL, String content) {
  //   String json = '';
  //   _post(restURL, content).then((value) => json = value);
  //   print('json-post: ${json}');
  //   return json;
  // }
  static var uuid = Uuid();

  static CognitoUserAttributeKey comeInIDCognitoKey =
      const CognitoUserAttributeKey.custom('comein_id');

  static String getUUID() {
    return uuid.v1() + '_' + uuid.v4();
  }

  static Future<String> post(String restURL, String content) async {
    return postQuery(restURL, content, null);
  }

  static Future<String> postQuery(
      String restURL, String content, Map<String, String>? params) async {
    try {
      AuthSession session = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );

      CognitoAuthSession cognitoSession = session as CognitoAuthSession;
      AuthUser user = await Amplify.Auth.getCurrentUser();

      String token = session.userPoolTokens!.idToken;
      print('token=${token}');

      Map<String, String> headers = {"comein_auth": token};

      //List<int> data = content.codeUnits;
      List<int> data = utf8.encode(content);
      print('post-content..by UTF-8');
      RestOptions options = RestOptions(
          apiName: 'comein-mobile-api',
          path: restURL,
          body: Uint8List.fromList(data),
          queryParameters: params,
          headers: {'comein_auth': token, 'Credential': token});

      print('POST call URL: ${restURL}');
      RestOperation restOperation = Amplify.API.post(restOptions: options);
      RestResponse response = await restOperation.response;

      String result = utf8.decode(response.data);
      print('JSON response by UTF-8: ${result}');
      return result;
    } on ApiException catch (e) {
      String error = e.message;
      print('POST call failed: ${error}');
      return error;
    }
  }

  static Future<UserInfo> profile() async {
    var res = await Amplify.Auth.fetchUserAttributes();
    UserInfo _info = initProfile(res);
    return _info;
  }

  static UserInfo initProfile(List<AuthUserAttribute> res) {
    String email = "";
    String firstname = "";
    String lastname = "";
    String mobile = "";
    String sub = "";
    res.forEach((element) {
      print('key: ${element.userAttributeKey}; value: ${element.value}');
      if (element.userAttributeKey == CognitoUserAttributeKey.givenName) {
        firstname = element.value;
      }
      if (element.userAttributeKey == CognitoUserAttributeKey.familyName) {
        lastname = element.value;
      }
      if (element.userAttributeKey == CognitoUserAttributeKey.email) {
        email = element.value;
      }
      if (element.userAttributeKey.key == 'sub') {
        sub = element.value;
        print('sub=${sub}');
      }
    });
    UserInfo info = UserInfo(email, firstname, lastname, mobile);
    info.comeinId = sub;
    return info;
  }

  static Future<String> get(String restURL) async {
    try {
      AuthSession session = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );

      CognitoAuthSession cognitoSession = session as CognitoAuthSession;
      AuthUser user = await Amplify.Auth.getCurrentUser();

      String token = session.userPoolTokens!.idToken;

      Map<String, String> headers = {"comein_auth": token};

      RestOptions options = RestOptions(
          apiName: 'comein-mobile',
          path: restURL,
          headers: {'comein_auth': token});

      print('POST call URL: ${restURL}');
      RestOperation restOperation = Amplify.API.get(restOptions: options);
      RestResponse response = await restOperation.response;

      String result = utf8.decode(response.data);
      print('JSON response by UTF-8: ${result}');
      return result;
    } on ApiException catch (e) {
      String error = e.message;
      print('POST call failed: ${error}');
      return error;
    }
  }

  static Future<String> initTokenOCR() async {
    var response = await http.post(
      Uri.parse(
          'http://comeinapi-env.eba-xpdwuwiv.ap-southeast-1.elasticbeanstalk.com/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // body: jsonEncode(<String, String>{
      //   'username': 'no-reply@thecomein.com',
      //   'password': 'comeIn@booking2022'
      // }),
      body:
          '{"username":"no-reply@thecomein.com","password":"comeIn@booking2022"}',
    );
    print('body: ${response.body}');
    var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    String token = jsonResponse['accessToken'];
    print('token=${token}');
    return token;
  }

  static Future<UserConfirm?> scanURLIDCard(
      String token, String imageURL) async {
    ByteData imageData = await NetworkAssetBundle(Uri.parse(imageURL)).load("");
    Int8List bytes = imageData.buffer.asInt8List();
    List<int> data = bytes.toList();
    print('image URL = ${imageURL}');
    print('data ${data}');
    return await scanIDCard(token, '', data);
  }

  static Future<UserConfirm?> scanIDCard(
      String token, String refId, List<int> data) async {
    print('scan with refId=${refId}');
    String apiURL =
        'http://comeinapi-env.eba-xpdwuwiv.ap-southeast-1.elasticbeanstalk.com/ocr/idcard';

    String _filename = 'id-card';
    var request = http.MultipartRequest('POST', Uri.parse(apiURL));
    request.headers.putIfAbsent('Authorization', () => 'Bearer ${token}');
    //request.fields['idcard'] = 'files';
    request.files.add(http.MultipartFile.fromBytes('idcard', data,
        filename: _filename, contentType: MediaType("image", "png")));
    print('send...');
    var response = await request.send();
    String json = await response.stream.bytesToString();
    print('response-body: ${json}');
    try {
      Map<String, dynamic> jsonMap = jsonDecode(json);
      dynamic idCardData = jsonMap['data'];

      UserConfirm confirm = UserConfirm.fromIDCardOCR(idCardData);

      return confirm;
    } on Exception catch (_) {
      return errorUserConfirm(refId);
    }
  }

  static UserConfirm errorUserConfirm(String refId) {
    Set<String> _title = {'นาย', 'นาง'};
    var random = Random();
    String _id = randomCardID();

    print('error to default UserConfirm - refId=${refId}');
    if (refId != '') {
      var r = new Random();
      if (r.nextBool()) {
        print('reset card-id from scan api');
        _id = refId;
      }
    }

    UserConfirm _confirm = UserConfirm(_id, 'NATIONAL_CARD', 'TH');
    _confirm.namePrefix = _title.elementAt(random.nextInt(1));
    _confirm.firstname = randomStr(8);
    _confirm.lastname = randomStr(8);

    return _confirm;
  }

  static String randomCardID() {
    var random = Random();
    int prefix = random.nextInt(8) + 1;
    String cardId = prefix.toString(); // + '-';
    for (var i = 0; i < 12; i++) {
      cardId = cardId + random.nextInt(9).toString();
    }
    // cardId = cardId + '-';
    // for (var i = 0; i < 5; i++) {
    //   cardId = cardId + random.nextInt(9).toString();
    // }
    // cardId = cardId + '-';
    // for (var i = 0; i < 2; i++) {
    //   cardId = cardId + random.nextInt(9).toString();
    // }
    // cardId = cardId + '-' + random.nextInt(9).toString();

    return cardId;
  }

  static String randomStr(int _index) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    var random = Random();
    String _value = '';
    for (var i = 0; i < _index; i++) {
      _value = _value + _chars[random.nextInt(_chars.length)];
    }
    return _value;
  }
}
