import 'dart:convert';

import 'package:dart_mpesa_api/mpesa/configs/mpesa_configs.dart';
import 'package:dart_mpesa_api/mpesa/modules/mpesa_modules.dart' show fetchMpesaToken;
import 'package:http/http.dart' as http;


class StkPushQueryRequest{

  StkPushQueryRequest({this.checkoutRequestID});

  final String checkoutRequestID;

  String _businessShortCode;
  String _password;
  String _timestamp;

  Future<Map<String, dynamic>> query() async{    
    // fetch configs
    const String _key = mpesaConsumerKey;
    const String _secret = mpesaConsumerSecret;
    const String _shortCode = mpesaBusinessShortCode;
    const String _passKey = mpesaPasskey;


    final Map<String, dynamic> _tokenRes = await fetchMpesaToken(key: _key, secret: _secret);
    final String accessToken =_tokenRes['body']['token'].toString();
    final now = DateTime.now();
    final String _dt = now.year.toString() + 
                      now.month.toString().padLeft(2, '0') + 
                      now.day.toString().padLeft(2, '0') + 
                      now.hour.toString().padLeft(2, '0') + 
                      now.minute.toString().padLeft(2, '0') + 
                      now.second.toString().padLeft(2, '0');
    final str = _shortCode + _passKey + _dt;
    final bytes = utf8.encode(str);

    _password = base64.encode(bytes);
    _timestamp = _dt;
    _businessShortCode = _shortCode;

    final Map<String, String> _payload = {
      "BusinessShortCode": _businessShortCode,
      "Password": _password,
      "Timestamp": _timestamp,
      "CheckoutRequestID": checkoutRequestID
    };

    final Map<String, String> headers = {
      'content-type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    const String url = mpesaStkPushQueryRequestUrl;
    
    Map<String, dynamic> _message;
    try{
      final http.Response _res = await http.post(url, headers: headers, body: json.encode(_payload));
      if(_res.statusCode == 200){
        _message = {
          'status': 0,
          'resultCode': json.decode(_res.body)['ResultCode'],
          'body': _res
        };
      } else {
        _message = {
          'status': 1,
          'body': _res
        };
      }
    } catch (e){
      _message = {
        'status': 101,
        'body': e
      };
    }

    return _message;

  }
}

