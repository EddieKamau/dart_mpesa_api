import 'package:dart_mpesa_api/dart_mpesa_api.dart';
import 'package:dart_mpesa_api/mpesa/controllers/mpesa_controllers.dart';

Router mpesaRoutes(Router router){

  // c2b stkpush
  router
    .route('/mpesa/stkpush')
    .link(()=> MpesaStkController());

  // b2c
  router
    .route('/mpesa/bc')
    .link(()=> MpesaBcController());
  
  // stkpush query request
  router
    .route('/mpesa/stkpushquery')
    .link(()=> MpesaStkpushQueryRequestController());
  
  return router;
}