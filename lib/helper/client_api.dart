import 'dart:convert';
import 'dart:typed_data';

import 'package:amplify_flutter/amplify_flutter.dart';

class ClientAPI {
  static Future<String> post(String restURL, String content) async {
    return postQuery(restURL, content, null);
  }

  static Future<String> postQuery(
      String restURL, String content, Map<String, String>? params) async {
    try {
      Map<String, String> _headers = {};

      List<int> data = utf8.encode(content);
      RestOptions options = RestOptions(
          apiName: 'client-api',
          path: restURL,
          body: Uint8List.fromList(data),
          queryParameters: params,
          headers: _headers);

      print('POST URL: ${restURL}');
      RestOperation restOperation = Amplify.API.post(restOptions: options);
      RestResponse response = await restOperation.response;

      String result = utf8.decode(response.data);
      print('response: ${result}');
      return result;
    } on ApiException catch (e) {
      String error = e.message;
      print('POST failed: ${error}');
      return error;
    }
  }
}
