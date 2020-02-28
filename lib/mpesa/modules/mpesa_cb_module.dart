import 'dart:convert';

import 'package:dart_mpesa_api/mpesa/configs/mpesa_configs.dart';
import 'package:dart_mpesa_api/mpesa/modules/mpesa_modules.dart' show fetchMpesaToken;
import 'package:http/http.dart' as http;

class MpesaCbModule{
  MpesaCbModule({this.phoneNo, this.amount, this.refNumber, this.transactionDesc});

  final String phoneNo; 
  final String amount;
  final String refNumber;
  final String transactionDesc;

  Future<Map<String, dynamic>> transact()async{
    // fetch configs
    const String _passKey = mpesaPasskey;
    const String _key = mpesaConsumerKey;
    const String _secret = mpesaConsumerSecret;
    const String _shortCode = mpesaBusinessShortCode;

    final Map<String, dynamic> _tokenRes = await fetchMpesaToken(key: _key, secret: _secret);
    if(_tokenRes['status'] != 0){
      return {
        "status": 3,
        "body": {
          "message": "error fetching token"
        }
      };
    } else {
      final String accessToken = _tokenRes['body']['token'].toString();

      final DateTime _now = DateTime.now();
      final String _dt = _now.year.toString() + 
                          _now.month.toString().padLeft(2, '0') + 
                          _now.day.toString().padLeft(2, '0') + 
                          _now.hour.toString().padLeft(2, '0') + 
                          _now.minute.toString().padLeft(2, '0') + 
                          _now.second.toString().padLeft(2, '0');
      final String _codeKeyDt = _shortCode + _passKey + _dt;
      final List<int> _bytes = utf8.encode(_codeKeyDt);
      final String _password = base64.encode(_bytes);

      final Map<String, dynamic> _payload = {
        "BusinessShortCode": _shortCode,
        "Password": _password,
        "Timestamp": _dt,
        "TransactionType": "CustomerPayBillOnline",
        "Amount": double.parse(amount),
        "PartyA": phoneNo,
        "PartyB": _shortCode,
        "PhoneNumber": phoneNo,
        "CallBackURL": '$mpesaCallBackUrl/cb/$refNumber',
        "AccountReference": refNumber,
        "TransactionDesc": transactionDesc
      };



      final Map<String, String> _headers = {
          'content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
      };

      try{
        final http.Response _res = await http.post(mpesaCbUrL, headers: _headers, body: json.encode(_payload));
        return {
          "status": 0,
          "body": _res
        };
      } catch (e){
        return {
          "status": 3,
          "body": "cannot reach endpoint"
        };
      }
    }
  }

}