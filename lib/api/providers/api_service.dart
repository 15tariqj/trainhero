import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:trainhero/env.dart';

final apiServiceProvider = Provider<APIService>((ref) {
  return APIService();
});

class APIService {
  Future<AsyncValue<bool>> registerUser(
    String email,
    String password,
    String firstName,
    String lastName,
    String phoneNo,
    String pushToken,
  ) async {
    try {
      var headers = {'hp': HEADER_PW};
      var data = jsonEncode({
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNo': phoneNo,
        'pushToken': pushToken,
      });

      var dio = Dio();
      var response = await dio.request(
        'http://auth.trainhero.uk/register/$URL_PW',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      return AsyncData(response.data['success'] == 1);
    } on Exception catch (_, e) {
      return AsyncValue.error("Something went wrong", e);
    }
  }
}
