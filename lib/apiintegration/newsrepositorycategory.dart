import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/newNewsCategoryApiModel.dart';

class NewsCategoryRepository {
  final String categoryName;
  NewsCategoryRepository(this.categoryName);

  Future<NewNewsCategoryApiModel> categoryApiFunction(String category) async {
    String url =
        "https://newsapi.org/v2/everything?q=$category&apiKey=09a1fcf60c3e457394d2e5bcd18e9d54";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewNewsCategoryApiModel.fromJson(body);
    } else {
      throw Exception("Error fetching category news");
    }
  }
}
