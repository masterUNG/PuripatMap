import 'package:flutter/material.dart';

class ShowMessageing extends StatefulWidget {
  final String title;
  final String message;
  const ShowMessageing({Key? key, required this.title, required this.message})
      : super(key: key);

  @override
  _ShowMessageingState createState() => _ShowMessageingState();
}

class _ShowMessageingState extends State<ShowMessageing> {
  String? title, messase;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.title = widget.title;
    this.messase = widget.message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Messageing'),
      ),
      body: Column(
        children: [
          Text('title ==> $title'),
           Text('message ==> $messase'),
        ],
      ),
    );
  }
}
