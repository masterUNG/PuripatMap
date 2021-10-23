import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ShowMap extends StatefulWidget {
  const ShowMap({Key? key}) : super(key: key);

  @override
  _ShowMapState createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  double? lat, lng;
  List<double> positions = [13.674202726633432, 100.60671334561246];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLatLng();
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
        print([lat, lng]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Map'),
      ),
      body: Text('Show Map'),
    );
  }
}
