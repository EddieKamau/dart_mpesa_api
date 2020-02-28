import 'dart:convert';

import 'package:dart_mpesa_api/mpesa/configs/mpesa_configs.dart';
import 'package:dart_mpesa_api/mpesa/modules/mpesa_modules.dart' show fetchMpesaToken;
import 'package:http/http.dart' as http;

class MpesaBcModule{
  MpesaBcModule({this.phoneNo, this.amount, this.refNumber, this.transactionDesc});

  final String phoneNo; 
  final String amount;
  final String refNumber;
  final String transactionDesc;

  Future<Map<String, dynamic>> transact()async{
    // fetch configs
    const String initiatorName = mpesaInitiatorName;
    const String securityCredential = mpesaSecurityCredential;
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

    final Map<String, dynamic> _payload = {
      "InitiatorName": initiatorName,
      "SecurityCredential": securityCredential,
      "CommandID": "BusinessPayment",
      "Amount": amount,
      "PartyA": _shortCode,
      "PartyB": phoneNo,
      "Remarks": transactionDesc,
      "QueueTimeOutURL": '$mpesaCallBackUrl/bc/$refNumber',
      "ResultURL": '$mpesaCallBackUrl/bc/$refNumber',
      "AccountReference": refNumber
  };



      final Map<String, String> _headers = {
          'content-type': 'application/json',
          'Authorization': 'Bearer $accessToken'
      };

      try{
        final http.Response _res = await http.post(mpesaBcUrL, headers: _headers, body: json.encode(_payload));
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