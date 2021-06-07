import 'dart:io';
import 'package:http/http.dart' as http;

class RecipeController {
  static Future<http.Response> getRecipes() async {
    var response =
        await http.get(Uri.parse("http://192.168.2.102:8080/recipes"));

    /// If the first API call is successful
    if (response.statusCode == HttpStatus.ok) {
      print(response);
    }

    /// Do other stuffs here
    print("lol");
    print(response.body);
    return response;
  }
}
