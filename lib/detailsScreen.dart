import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailsScreen extends StatefulWidget {
  final String objectID;
  DetailsScreen({required this.objectID});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  var detailsData;
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    http.Response response = await http.get(
        Uri.parse("http://hn.algolia.com/api/v1/items/${widget.objectID}"));

    setState(() {
      detailsData = jsonDecode(response.body);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              title: Text(detailsData['title']),
            ),
            body: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: detailsData['children'].length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Text(
                      detailsData['children'][index]['text'],
                      style: TextStyle(color: Colors.red.shade900),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                );
              },
            ),
          );
  }
}
