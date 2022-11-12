import 'dart:async';
import 'dart:convert';
import 'photo.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class PhotoService {
  static const photoApi = 'https://jsonplaceholder.typicode.com/photos';
  static final httpClient = http.Client();

  List<Photo> parsePhotos(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
  }

  Future<List<Photo>> fetchPhotos() async {
    final response = await httpClient.get(Uri.parse(photoApi));
    return compute(parsePhotos, response.body);
  }
}