import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:search_app/detailsScreen.dart';
import 'package:search_app/searchForm.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key, required this.title}) : super(key: key);

  final String title;
  final dio = Dio();

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var news;
  List<dynamic> newsHits = [];

  Future<void> searchRestaurants(String query) async {
    final Response response = await widget.dio.get(
      'http://hn.algolia.com/api/v1/search?query=$query',
    );
    setState(() {
      news = jsonDecode(response.toString());
    });
    newsHits = news['hits'];
    print('News issssssssssssssssssssssssssssss : $news');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.red,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          SearchForm(
            onSearch: searchRestaurants,
          ),
          Expanded(
            child: news == null
                ? Text("nothing to show")
                : ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: newsHits.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                    objectID: newsHits[index]['objectID'],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              child: Text(
                                newsHits[index]['title'],
                                style: TextStyle(color: Colors.red.shade900),
                              ),
                              color: Colors.amberAccent,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
