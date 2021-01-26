import 'dart:io';

import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  final String filePath;

  const DetailsScreen({Key key, this.filePath}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String bodyText = "";

  setText() async {
    File textFile = File(widget.filePath);
    final contents = await textFile.readAsString();

    setState(() {
      bodyText = contents;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    setText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Text(bodyText),
      ),
    );
  }
}
