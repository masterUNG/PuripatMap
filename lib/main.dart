import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:puripatmap/states/show_map.dart';

Map<String, WidgetBuilder> map = {
  '/showMap': (BuildContext context) => const ShowMap(),
};

String? initialRoute;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    // print('## Firebase Initial Success');
    // FirebaseMessaging.onBackgroundMessage((message) => null);
    initialRoute = '/showMap';
    runApp(const MyApp());
  });
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
