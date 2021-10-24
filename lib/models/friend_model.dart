import 'dart:convert';

class FriendModel {
  final String name;
  final String lat;
  final String lng;
  FriendModel({
    required this.name,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lat': lat,
      'lng': lng,
    };
  }

  factory FriendModel.fromMap(Map<String, dynamic> map) {
    return FriendModel(
      name: map['name'],
      lat: map['lat'],
      lng: map['lng'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FriendModel.fromJson(String source) => FriendModel.fromMap(json.decode(source));
}
