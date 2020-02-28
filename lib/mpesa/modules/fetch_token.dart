import 'dart:convert';

import 'package:dart_mpesa_api/mpesa/configs/mpesa_configs.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchMpesaToken({String key, String secret})async{
  final String username = key;
  final String password =  secret;
  final _base64E = base64Encode(utf8.encode('$username:$password'));
  final String basicAuth = 'Basic $_base64E';

  try{
    final http.Response _res = await http.get(mpesaTokenUrl, headers: <String, String>{'authorization': basicAuth});
    if(_res.statusCode == 200){
      final _body = json.decode(_res.body);
      return {
        "status": 0,
        "body": {
          "token": _body['access_token'].toString()
        }
      };
    } else {
      return {
        "status": 1,
        "body": {
          "message": json.decode(_res.body)
        }
      };
    }
  }catch (e){
    return {
      "status": 3,
      "body": {
        "message": "cannot reach endpoint"
      }
    };
  }

}