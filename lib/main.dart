import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(RestaurantSearchApp());
}

class RestaurantSearchApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchPage(title: 'Search Page'),
    );
  }
}

class SearchPage extends StatefulWidget {
  SearchPage({Key? key, required this.title}) : super(key: key);

  final String title;
  final dio = Dio();

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List _news = [];

  Future<void> searchRestaurants(String query) async {
    final Response response = await widget.dio.get(
      'http://hn.algolia.com/api/v1/search?query=$query',
    );
    var responseMap = jsonDecode(response.toString());
    print(responseMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            SearchForm(
              onSearch: searchRestaurants,
            ),
            _news == null
                ? Text('No results to display')
                : Expanded(
                    child: ListView(
                      children: _news.map((news) {
                        return ListTile(
                          title: Text(news['hits']['title']),
                          subtitle: Text(news['hits']['author']),
                          trailing: Text(news['hits']['num_comments']),
                        );
                      }).toList(),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class SearchForm extends StatefulWidget {
  SearchForm({required this.onSearch});

  final void Function(String search) onSearch;

  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();
  var _autovalidate = false;
  var _search;

  @override
  Widget build(BuildContext context) {
    return Form(
      // ignore: deprecated_member_use
      autovalidate: _autovalidate,
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search Here',
                border: OutlineInputBorder(),
                filled: true,
              ),
              onChanged: (value) {
                _search = value;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter';
                }
                return null;
              }),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                final isValid = _formKey.currentState!.validate();
                if (isValid) {
                  widget.onSearch(_search);
                } else {
                  setState(() {
                    _autovalidate = true;
                  });
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Search',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
