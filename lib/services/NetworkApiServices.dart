import 'dart:convert';
import 'dart:io';

import 'package:carwash/apis/app_exception.dart';
import 'package:carwash/services/BaseApiServices.dart';
import 'package:http/http.dart' as https;
import 'package:logger/logger.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  dynamic responseJson;

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      https.Response response = await https.post(
        Uri.parse(url),
        body: data,
      );

      var logger = Logger();
      //logger.d(response.body);
      logger.d(url);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No! Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getPostAuthApiResponse(String url, dynamic data, String token) async {
    try {
      /*final ioc = new HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      */
      https.Response response = await https.post(Uri.parse(url), body: data, headers: {'Authorization': 'Bearer $token'});
      var logger = Logger();
      logger.d(response.body);
      //logger.d(url);
      responseJson = returnResponse(response);
    } catch (e) {
      var logger = Logger();
      logger.d(e.toString());
    }
    return responseJson;
  }

  dynamic returnResponse(https.Response response) {
    var logger = Logger();
    //logger.d('${response.body}');
    print(response.statusCode);

    dynamic responseJson = jsonDecode(response.body);
    switch (response.statusCode) {
      case 200:
        return responseJson;
      case 400:
        throw BadRequestException(responseJson['message'].toString());
      default:
        return responseJson;
    //case 401:
    //case 403:
    //throw UnauthorisedException(responseJson['message'].toString());
    //case 422:
    //throw BadRequestException(responseJson['message'].toString());
    //case 500:
    //default:
    //throw FetchDataException('Error occurred while communication with server');
    }
  }
}
