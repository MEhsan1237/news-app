import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api/newNewsCategoryApiModel.dart';


import '../apiintegration/newsrepositorycategory.dart';
import '../main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class BottomScreen extends StatefulWidget {
  const BottomScreen({super.key});

  @override
  State<BottomScreen> createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  String category = 'general';
  final format = DateFormat('MMMM dd, yyyy');

  late NewsCategoryRepository newsCategoryRepository = NewsCategoryRepository(category);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return FutureBuilder<NewNewsCategoryApiModel>(
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
            shrinkWrap: true,  // ✅ apni height jitni hai utni hi lega
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.articles!.length,
            itemBuilder: (context, index) {

              DateTime? dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());

              return Padding(
                padding: const EdgeInsets.only(bottom: 6.0,top: 8,left: 14),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        height: height*.18,
                        width: width*.26,
                        imageUrl: snapshot.data!.articles![index].urlToImage.toString() ,
                        placeholder: (context, url) => Container(child: spinKit),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Expanded(
                      child: Container(

                        height: height*.18,
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
    );
  }
}
