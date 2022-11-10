import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

const albumsApi = 'https://jsonplaceholder.typicode.com/albums';

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
  final response = await http.get(Uri.parse('$albumsApi'));

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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue
      ),
      home: const BottomNavigation()
    );
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  late Future<List<Album>> futureAlbumList;

  @override
  void initState(){
    super.initState();
    futureAlbumList = fetchAlbumList();
  }

  Widget getWidget(){
    return FutureAlbumListView(futureAlbumList: futureAlbumList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Json Placeholder'),
      ),
      body: getWidget(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.album),
            label: 'Albums'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Photos'
          )
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class FutureAlbumListView extends StatelessWidget {
  final Future<List<Album>> futureAlbumList;
  const FutureAlbumListView({super.key, required this.futureAlbumList});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Album>>(
      future: futureAlbumList,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return AlbumListView(albumList: snapshot.data!);
        }else if(snapshot.hasError){
          return Center(
            child: Text('${snapshot.error}')
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
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
        return const Divider();
      },
    );
  }
}
