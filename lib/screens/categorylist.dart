import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api/newNewsCategoryApiModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../apiintegration/newsrepositorycategory.dart';
import '../main.dart';
import 'package:intl/intl.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late NewsCategoryRepository newsCategoryRepository = NewsCategoryRepository(category);
  final format = DateFormat('MMMM dd, yyyy');
  String category = 'general';

  @override
  Widget build(BuildContext context) {
    List<String> AllListNames = [
      "General",
      "Entertainment",
      "Health",
      "Sports",
      "Business",
      "Technology",
    ];
    final width = MediaQuery
        .of(context)
        .size
        .width * 1;
    final height = MediaQuery
        .of(context)
        .size
        .height * 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: AllListNames.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            category = AllListNames[index];
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: category == AllListNames[index]
                                  ? Colors.blue
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Center(
                                child: Text(
                                  AllListNames[index].toString(),
                                  style: GoogleFonts.actor(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),

                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: FutureBuilder<NewNewsCategoryApiModel>(
                    future: newsCategoryRepository.categoryApiFunction(category),

                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: spinKit);
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.articles == null) {
                        return Center(child: Text("No data available"));
                      } else {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.articles!.length,
                          itemBuilder: (context, index) {

                            DateTime? dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0,top: 6),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      height: height*.19,
                                      width: width*.28,
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString() ,
                                      placeholder: (context, url) => Container(child: spinKit),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(

                                      height: height*.19,
                                      padding: EdgeInsets.only(left: 15, right: 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(snapshot.data!.articles![index].title.toString(),
                                            style: GoogleFonts.actor(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),
                                            maxLines: 3,
                                          ),
                                          Spacer(),
                                          Row(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(child: Text(snapshot.data!.articles![index].source!.name.toString(),overflow: TextOverflow.ellipsis,)),
                                              Text(format.format(dateTime),overflow: TextOverflow.ellipsis)
                                            ],
                                          )
                                        ],),
                                    ),
                                  )




                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                )
              ]
          )
      ),
    );
  }
}

