
import 'package:flutter/material.dart';

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
