import 'package:dart_mpesa_api/dart_mpesa_api.dart';

class MpesaStkpushQuerySerializer extends Serializable{
  String checkoutRequestID; 
  @override
  Map<String, dynamic> asMap() {
    return {
      'checkoutRequestID': checkoutRequestID,
    };
  }


  @override
  void readFromMap(Map<String, dynamic> object) {
    checkoutRequestID = object['checkoutRequestID'].toString();
  }
  

}