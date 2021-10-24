import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:puripatmap/models/friend_model.dart';
import 'package:puripatmap/models/message_model.dart';
import 'package:puripatmap/states/show_messageing.dart';

class ShowMap extends StatefulWidget {
  const ShowMap({Key? key}) : super(key: key);

  @override
  _ShowMapState createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  double? lat, lng;
  List<double> positions = [13.674202726633432, 100.60671334561246];

  Map<MarkerId, Marker> markers = {};
  int i = 0;

  List<double> busStopDou = [13.670397667843352, 100.62428717942036];

  BitmapDescriptor? busStopBitmap;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLatLng();
    readData();

    buildBusStop();

    createMarker(LatLng(busStopDou[0], busStopDou[1]), 'Bus Stop',
        'ป้ายรถเมย์ หน้าหมู่บ้าน');

    findToken();
  }

  Future<void> findToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      String token = value.toString();
      print('## token = $token');
    });

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission();
    print('## settings ==> ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((event) {
      print('## event ==> ${event.data}');

      MessageModel model = MessageModel.fromMap(event.data);
      print('## title ==> ${model.title}');

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ShowMessageing(title: model.title, message: model.body),
          ));
    });

    // FirebaseMessaging.onBackgroundMessage((message) {
    //   print('## message ==>> ${message.data}');
      
    // });
  }

  Future<void> buildBusStop() async {
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(48, 48)), 'images/bus.png')
        .then((value) {
      setState(() {
        busStopBitmap = value;
      });
    });
  }

  Future<void> readData() async {
    String path = 'https://www.androidthai.in.th/bigc/getAllUser.php';
    await Dio().get(path).then((value) {
      // print('value ==>> $value');
      json.decode(value.data).forEach((element) {
        FriendModel model = FriendModel.fromMap(element);
        // print('## name = ${model.name}');
        LatLng latLng =
            LatLng(double.parse(model.lat.trim()), double.parse(model.lng));
        createMarker(latLng, model.name, '[${model.lat}, ${model.lng}]', 90);
      });
    });
  }

  Future<void> findLatLng() async {
    bool locationServiceEnable = await Geolocator.isLocationServiceEnabled();

    if (locationServiceEnable) {
      print('## Location Enable');

      LocationPermission locationPermission =
          await Geolocator.checkPermission();
      print('current locationPermission ==> $locationPermission');

      if (locationPermission == LocationPermission.denied) {
        // ไม่มีรู้ว่าแชร์หรือเปล่า
        await Geolocator.requestPermission().then((value) async {
          locationPermission = await Geolocator.checkPermission();
          if (locationPermission == LocationPermission.deniedForever) {
            // ไม่อนุญาติเลย
            print('ไม่อนุญาติเลย');
            Geolocator.openAppSettings();
          } else {
            // ไปหา lat,lng
            print('ไปหา lat,lng');
            await findPosition();
          }
        });
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          // ไม่อนุญาติเลย
          print('ไม่อนุญาติเลย');
          Geolocator.openAppSettings();
        } else {
          // ไปหา lat,lng
          print('ไปหา lat,lng');
          findPosition();
        }
      }
    } else {
      print('## Location Non Enable');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('กรณาเปิด Service Location ด้วย'),
          actions: [
            TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await Geolocator.openLocationSettings().then((value) {
                    exit(0);
                  });
                },
                child: const Text('OK'))
          ],
        ),
      );
    }
  }

  Future<void> findPosition() async {
    await Geolocator.getCurrentPosition().then((value) {
      setState(() {
        lat = value.latitude;
        lng = value.longitude;
        // print([lat, lng]);
        createMarker(LatLng(lat!, lng!), 'คุณอยู่ที่นี่', '[$lat, $lng],', 240);
      });
    });
  }

  void createMarker(LatLng latLng, String title, String detail,
      [double? douHue]) {
    MarkerId markerId = MarkerId('id${i++}');
    Marker marker = Marker(
      markerId: markerId,
      position: latLng,
      infoWindow: InfoWindow(title: title, snippet: detail),
      icon: douHue == null
          ? busStopBitmap == null
              ? BitmapDescriptor.defaultMarker
              : busStopBitmap!
          : BitmapDescriptor.defaultMarkerWithHue(douHue),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Map'),
      ),
      body: lat == null
          ? const Center(child: CircularProgressIndicator())
          : buildMap(),
    );
  }

  GoogleMap buildMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(lat!, lng!),
        zoom: 16,
      ),
      onMapCreated: (controller) {},
      markers: Set<Marker>.of(markers.values),
    );
  }
}
