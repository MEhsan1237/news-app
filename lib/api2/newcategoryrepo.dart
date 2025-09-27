class NewNewsCategoryApiModel {
  List<Article>? articles;

  NewNewsCategoryApiModel({this.articles});

  NewNewsCategoryApiModel.fromJson(Map<String, dynamic> json) {
    if (json['articles'] != null) {
      articles = <Article>[];
      json['articles'].forEach((v) {
        articles!.add(Article.fromJson(v));
      });
    }
  }
}

class Article {
  String? title;
  String? publishedAt;
  Source? source;
  String? urlToImage;

  Article({this.title, this.publishedAt, this.source, this.urlToImage});

  Article.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    publishedAt = json['publishedAt'];
    source =
    json['source'] != null ? Source.fromJson(json['source']) : null;
    urlToImage = json['urlToImage'];
  }
}

class Source {
  String? name;

  Source({this.name});

  Source.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }
}
