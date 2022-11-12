import 'dart:async';
import 'dart:convert';
import 'album.dart';
import 'package:http/http.dart' as http;

class AlbumService {

  static const albumsApi = 'https://jsonplaceholder.typicode.com/albums';

  Future<List<Album>> fetchAlbumList() async {
    final response = await http.get(Uri.parse(albumsApi));

    if(response.statusCode == 200){
      Iterable list = jsonDecode(response.body);
      return List<Album>.from(list.map((json) => Album.fromJson(json)));
    }else{
      throw Exception('Failed to load albums');
    }
  }

  Future<Album> fetchAlbum(int id) async {
    final response = await http.get(Uri.parse('$albumsApi/$id'));

    if(response.statusCode == 200) {
      return Album.fromJson(jsonDecode(response.body));
    }else {
      throw Exception('Failed to load album');
    }
  }
}