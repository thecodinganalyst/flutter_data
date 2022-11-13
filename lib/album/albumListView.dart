import 'package:flutter/material.dart';
import 'package:flutter_data/album/albumFormView.dart';
import 'package:flutter_data/album/albumService.dart';
import 'album.dart';

class FutureAlbumListView extends StatefulWidget {
  const FutureAlbumListView({Key? key}) : super(key: key);

  @override
  State<FutureAlbumListView> createState() => _FutureAlbumListViewState();
}

class _FutureAlbumListViewState extends State<FutureAlbumListView> {
  late Future<List<Album>> futureAlbumList;
  final albumService = AlbumService();

  @override
  void initState(){
    super.initState();
    futureAlbumList = albumService.fetchAlbumList();
  }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
      ),
      body: ListView.separated(
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
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AlbumFormView()));
        },
      ),
    );


  }
}