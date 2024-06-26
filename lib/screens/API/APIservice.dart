import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Article.dart';

class ApiService {
  static const _baseUrl =
      'https://newsapi.org/v2/everything?q=women%20period%20menstruation&pageSize=10&page=1&apiKey=75af6b5c142a49109f2716983d1cf200';

  static Future<List<Article>> getArticles() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result['articles'];
      return list.map((article) => Article.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load data from API');
    }
  }
}
