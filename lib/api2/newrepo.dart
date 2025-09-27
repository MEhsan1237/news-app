import 'package:news_app/api/NewNewsHeadLinesApiModel.dart';
import '../apiintegration/newsrepositoryheadlines.dart';

class NewsChannelRepository {
  final NewsHeadLineRepository _rep = NewsHeadLineRepository();
  final String source; // ✅ add variable

  // ✅ constructor
  NewsChannelRepository(this.source);

  Future<NewNewsHeadLinesApiModel> headLinesApiFunction() async {
    return await _rep.headLinesApiFunction(source);
  }
}





