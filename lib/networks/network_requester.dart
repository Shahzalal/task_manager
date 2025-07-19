import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:taskmanager/utils/userdata.dart';

class NetworkRequester {
  ///Get Method
  Future<dynamic> getRequest(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'token': UserData.token ?? '',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        Logger().e("GET Request failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      Logger().e("GET Request Error:$e");
      return null;
    }
  }

  /// POST Method
  Future<dynamic> postRequest(String url, Map<String, String> body) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'token': UserData.token ?? '',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
      } else {
        Logger().e("POST Request failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      Logger().e("POST Request Error:$e");
      return null;
    }
  }

  /// Multipart Request Method (for file uploads like profile photo)
  Future<dynamic> multipartRequest(
    String url,
    Map<String, String> body,
    String? filePath,
  ) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll(body);
    request.headers.addAll({'token': UserData.token ?? ''});

    if (filePath != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', filePath));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      final resString = await response.stream.bytesToString();
      return jsonDecode(resString);
    } else {
      return null;
    }
  }
}
