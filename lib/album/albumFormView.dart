import 'package:flutter/material.dart';
import 'package:flutter_data/album/albumService.dart';
import 'album.dart';

class AlbumFormView extends StatefulWidget {
  const AlbumFormView({Key? key}) : super(key: key);

  @override
  State<AlbumFormView> createState() => _AlbumFormViewState();
}

class _AlbumFormViewState extends State<AlbumFormView> {
  final AlbumService _albumService = AlbumService();
  final TextEditingController _controller = TextEditingController();
  Future<Album>? _futureAlbum;

  Column buildColumn(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Enter Title'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureAlbum = _albumService.createAlbum(_controller.text);
            });
          },
          child: const Text('Create Data')
        )
      ],
    );
  }

  FutureBuilder<Album> buildFutureBuilder(){
    return FutureBuilder<Album>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return Text(snapshot.data!.title);
        }else if(snapshot.hasError){
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Album',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Album'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_futureAlbum == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ),
    );
  }
}
