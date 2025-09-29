import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatefulWidget {
  String newImage, source, description, newsTitle, newsDate, content;

  DetailScreen({
    super.key,
    required this.newImage,
    required this.source,
    required this.description,

    required this.newsTitle,
    required this.newsDate,
    required this.content,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final format = DateFormat('MMMM dd, yyyy');
  late DateTime? dateTime = DateTime.parse(widget.newsDate.toString());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_outlined),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SizedBox(
            height: height * .55,
            width: MediaQuery.of(context).size.width,

            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.newImage,
                placeholder: (context, url) => SpinKitFadingCircle(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: height * .6,
            margin: EdgeInsets.only(top: height * .4),
            padding: EdgeInsets.only(top: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: ListView(
              padding: EdgeInsets.all(15),
              children: [
                Text(
                  widget.newsTitle,
                  style: GoogleFonts.akshar(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: height * .02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.source),
                    Text(format.format(dateTime!)),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  widget.description,
                  style: GoogleFonts.akatab(
                    color: Colors.deepOrangeAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
