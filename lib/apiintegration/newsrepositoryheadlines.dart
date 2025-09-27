import 'dart:convert';

import 'package:http/http.dart' as http;

import '../api/NewNewsHeadLinesApiModel.dart';



class NewsHeadLineRepository {
  Future<NewNewsHeadLinesApiModel> headLinesApiFunction(String  source) async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=$source&apiKey=09a1fcf60c3e457394d2e5bcd18e9d54";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewNewsHeadLinesApiModel.fromJson(body);
    } else {
      throw Exception("Error fetching headlines");
    }
  }
}
