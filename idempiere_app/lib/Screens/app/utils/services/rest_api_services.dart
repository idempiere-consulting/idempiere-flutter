/* //import 'package:idempiere_app/Screens/app/shared_components/task_card.dart';

/// contains all service to get data from Server
class RestApiServices {
  static final RestApiServices _restApiServices = RestApiServices._internal();

  factory RestApiServices() {
    return _restApiServices;
  }
  RestApiServices._internal();

  /* Future<List<TaskCardData>> getAllLeads()async{

    var url = Uri.parse('http://' + ip + '/api/v1/auth/tokens');
     
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
  } */

  // to get data from server, you can use Http for simple feature
  // or Dio for more complex feature

  // Example:
  // Future<ProductDetail?> getProductDetail(int id)async{
  //   var uri = Uri.parse(ApiPath.product + "/$id");
  //   try {
  //     return await Dio().getUri(uri);
  //   } on DioError catch (e) {
  //     print(e);
  //   } catch (e) {
  //     print(e);
  //   }
  // }
} */

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
