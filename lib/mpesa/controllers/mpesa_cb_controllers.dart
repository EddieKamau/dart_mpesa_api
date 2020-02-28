import 'dart:convert';

import 'package:dart_mpesa_api/dart_mpesa_api.dart';
import 'package:dart_mpesa_api/mpesa/modules/mpesa_modules.dart' show MpesaCbModule;
import 'package:dart_mpesa_api/mpesa/serializers/mpesa_serializers.dart' show MpesaCbSerializer;

class MpesaStkController extends ResourceController{

 
  @Operation.post()
  Future<Response> create(
    @Bind.body(require: ['amount', 'phoneNo', 'refNumber', 'transactionDesc']) 
    MpesaCbSerializer mpesaCbSerializer) async{


      final MpesaCbModule _mpesaCbModule =  MpesaCbModule(
        refNumber: mpesaCbSerializer.refNumber,
        phoneNo: mpesaCbSerializer.phoneNo,
        amount: mpesaCbSerializer.amount,
        transactionDesc: mpesaCbSerializer.transactionDesc,
      );
      final Map<String, dynamic> _mpesaRes = await _mpesaCbModule.transact();

      // compute response
      if(_mpesaRes['status'] != 0){
        return Response.serverError(body: {'message': 'An error occured!'});
      } else {
        dynamic _responseBody;
        final int _responseStatusCode = int.parse(_mpesaRes['body'].statusCode.toString());
        
        try {
          _responseBody = json.decode(_mpesaRes['body'].body.toString());
          _responseBody['refNumber'] = mpesaCbSerializer.refNumber;
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