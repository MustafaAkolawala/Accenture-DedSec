import 'dart:convert';

import 'package:http/http.dart' as http;


fetchdata(String url, String value) async {
  http.Response response = await http.post(
      Uri.parse(url), headers: {'Content_Type':'application/json'},body: {'query': value});
  print(response.body);
  Map<String,dynamic> data = jsonDecode(response.body);
  return Future.value(data['response']+ '<bot>');




}