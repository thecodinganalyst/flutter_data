import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

const AlbumsApi = 'https://jsonplaceholder.typicode.com/albums';

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title']
    );
  }
}

Future<List<Album>> fetchAlbumList() async {
  final response = await http.get(Uri.parse('$AlbumsApi'));

  if(response.statusCode == 200){
    Iterable list = jsonDecode(response.body);
    return List<Album>.from(list.map((json) => Album.fromJson(json)));
  }else{
    throw Exception('Failed to load albums');
  }
}

Future<Album> fetchAlbum(int id) async {
  final response = await http.get(Uri.parse('$AlbumsApi/$id'));

  if(response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  }else {
    throw Exception('Failed to load album');
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Album>> futureAlbumList;

  @override
  void initState(){
    super.initState();
    futureAlbumList = fetchAlbumList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: FutureBuilder<List<Album>>(
          future: futureAlbumList,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return AlbumListView(albumList: snapshot.data!);
            }else if(snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class AlbumListView extends StatelessWidget {
  final List<Album> albumList;

  const AlbumListView({super.key, required this.albumList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: albumList.length,
      itemBuilder: (context, i) {
        final album = albumList[i];
        return ListTile(
          leading: Text(album.id.toString()),
          title: Text(album.title),
        );
      },
      separatorBuilder: (context, i) {
        return Divider();
      },
    );
  }
}
