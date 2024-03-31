import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

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
    String urlPw = dotenv.env['URL_PW'] ?? '';
    String headerPw = dotenv.env['HEADER_PW'] ?? '';
    try {
      var headers = {'hp': headerPw};
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
        'http://auth.trainhero.uk/register/$urlPw',
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
