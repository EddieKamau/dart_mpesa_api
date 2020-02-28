import 'package:dart_mpesa_api/dart_mpesa_api.dart';

class MpesaCbSerializer extends Serializable{
  String phoneNo; 
  String amount;
  String refNumber;
  String transactionDesc;
  @override
  Map<String, dynamic> asMap() {
    return {
      'phoneNo': phoneNo,
      'amount': amount,
      'refNumber': refNumber,
      'transactionDesc': transactionDesc,
    };
  }

  @override
  void read(Map<String, dynamic> object, {Iterable<String> ignore, Iterable<String> reject, Iterable<String> require}) {
    final String _phoneNo = object['phoneNo'].toString();
    final RegExp _allAreNumbers = RegExp(r'(^[0-9]{12}$)');
    final RegExp _startsWith = RegExp(r'(^2547)');
    Iterable<String> _reject;
    if(_allAreNumbers.hasMatch(_phoneNo) && _startsWith.hasMatch(_phoneNo)){
      _reject = reject;
      try {
        double.parse(object['amount'].toString());
        _reject = reject;
        if(double.parse(object['amount'].toString()) < 0){
          _reject = ['amount'];
        }
      } catch (e) {
        _reject = ['amount'];
      }
    } else{
      _reject = ['phoneNo'];
    }

    super.read(object, ignore: ignore, reject: _reject, require: require);
  }

  @override
  void readFromMap(Map<String, dynamic> object) {
    phoneNo = object['phoneNo'].toString(); 
    amount = object['amount'].toString();
    refNumber = object['refNumber'].toString();
    transactionDesc = object['transactionDesc'].toString();
  }
  

}