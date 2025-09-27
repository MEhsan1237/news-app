import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/screens/bottomscreen.dart';
import 'package:news_app/screens/categorylist.dart';
import 'package:news_app/screens/detailsscreen.dart';
import 'package:news_app/splash/splashscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'api/NewNewsHeadLinesApiModel.dart';
import 'apiintegration/newsrepositorycategory.dart';
import 'apiintegration/newsrepositoryheadlines.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen()));
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

enum FilterList { bbcNews, aryNews, alJazeeraNews }

class _MainScreenState extends State<MainScreen> {
  final NewsHeadLineRepository newsHeadLineRepository =
      NewsHeadLineRepository();
  final format = DateFormat('MMMM dd, yyyy');
  String categoryName = 'general';
  late NewsCategoryRepository newsCategoryRepository = NewsCategoryRepository(
    categoryName,
  );
  FilterList? selectedMenu;
  String name = "bbc-news"; // ✅ default channel

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoryScreen()),
            );
          },
          icon: Image.asset(
            "assets/images/splash.two.png",
            width: 20,
            height: 20,
          ),
        ),
        title: Text(
          "News Headlines",
          style: GoogleFonts.aleo(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,

        // ✅ PopupMenuButton for filter
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            onSelected: (FilterList item) {
              setState(() {
                if (FilterList.bbcNews.name == item.name) {
                  name = "bbc-news";
                }
                if (FilterList.aryNews.name == item.name) {
                  name = "ary-news";
                }
                if (FilterList.alJazeeraNews.name == item.name) {
                  name = "al-jazeera-english";
                }
                selectedMenu = item;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
              PopupMenuItem<FilterList>(
                value: FilterList.bbcNews,
                child: Text("bbc-news"),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.aryNews,
                child: Text("ary-news"),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.alJazeeraNews,
                child: Text("al-jazeera-news"),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            width: width,
            child: FutureBuilder<NewNewsHeadLinesApiModel>(
              future: newsHeadLineRepository.headLinesApiFunction(name),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: spinKit);
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData ||
                    snapshot.data!.articles == null) {
                  return Center(child: Text("No data available"));
                } else {
                  return ListView.builder(
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      final article = snapshot.data!.articles![index];
                      DateTime? dateTime = DateTime.parse(
                        article.publishedAt ?? "",
                      );

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                newImage: snapshot
                                    .data!
                                    .articles![index]
                                    .urlToImage
                                    .toString(),
                                source: snapshot
                                    .data!
                                    .articles![index]
                                    .source!.name
                                    .toString(),
                                description: snapshot
                                    .data!
                                    .articles![index]
                                    .description
                                    .toString(),

                                newsTitle: snapshot.data!.articles![index].title
                                    .toString(),
                                newsDate: snapshot
                                    .data!
                                    .articles![index]
                                    .publishedAt
                                    .toString(),
                                content: snapshot.data!.articles![index].content
                                    .toString(),
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: width * .9,
                              height: height,
                              padding: EdgeInsets.symmetric(
                                horizontal: height * .022,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: article.urlToImage ?? "",
                                  placeholder: (context, url) =>
                                      Container(child: spinKit),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(15),
                                  alignment: Alignment.bottomCenter,
                                  width: width * .76,
                                  height: height * .22,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article.title ?? "No Title",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.actor(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              article.source?.name ?? "Unknown",
                                            ),
                                          ),
                                          if (dateTime != null)
                                            Text(format.format(dateTime)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          BottomScreen(),
        ],
      ),
    );
  }
}

const spinKit = SpinKitFadingCircle(color: Colors.deepOrangeAccent, size: 40);
