import 'dart:convert';
import 'package:dio/dio.dart';

class HttpService {
  static Stream<String> postStream({
    required String url,
    Map? body,
  }) async* {
    Response response = await Dio().post(
      url,
      data: body,
      options: Options(
        contentType: 'application/json',
        responseType: ResponseType.stream,
      ),
    );

    Stream<List<int>> stream = response.data!.stream;
    await for (var chunk in stream) {
      yield utf8.decode(chunk);
    }
  }
}
