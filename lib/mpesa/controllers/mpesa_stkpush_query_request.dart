import 'dart:convert';

import 'package:dart_mpesa_api/dart_mpesa_api.dart';
import 'package:dart_mpesa_api/mpesa/modules/mpesa_modules.dart' show StkPushQueryRequest;
import 'package:dart_mpesa_api/mpesa/serializers/mpesa_serializers.dart' show MpesaStkpushQuerySerializer;

class MpesaStkpushQueryRequestController extends ResourceController{

 
  @Operation.post()
  Future<Response> create(
    @Bind.body(require: ['checkoutRequestID']) 
    MpesaStkpushQuerySerializer mpesaStkpushQuerySerializer) async{

      final StkPushQueryRequest _stkPushQueryRequest =  StkPushQueryRequest(
        checkoutRequestID: mpesaStkpushQuerySerializer.checkoutRequestID,
      );
      final Map<String, dynamic> _mpesaRes = await _stkPushQueryRequest.query();

      // compute response
      if(_mpesaRes['status'] != 0){
        return Response.serverError(body: {'message': 'An error occured!'});
      } else {
        dynamic _responseBody;
        final int _responseStatusCode = int.parse(_mpesaRes['body'].statusCode.toString());
        
        try {
          _responseBody = json.decode(_mpesaRes['body'].body.toString());
        } catch (e) {
          _responseBody = _mpesaRes['body'].body; 
        }
        _responseBody = {'body': _responseBody};

        switch (_responseStatusCode) {
          case 200:
            return Response.ok(_responseBody);
            break;
          case 400:
            return Response.badRequest(body: _responseBody);
            break;
          default:
          return Response.serverError(body: _responseBody);
        }
      }
      
    }
 
}