import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key key}) : super(key: key);

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Search Tab",style: TextStyle(fontSize: 45.0),),
    );
  }
}
