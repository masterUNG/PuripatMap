import 'package:flutter/material.dart';
import 'package:puripatmap/states/show_map.dart';

Map<String, WidgetBuilder> map = {
  '/showMap': (BuildContext context) => const ShowMap(),
};

String? initialRoute;

void main() {
  initialRoute = '/showMap';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: map,
      initialRoute: initialRoute,
    );
  }
}
