import 'package:flutter/material.dart';
import 'package:flutter_data/photo/photoService.dart';
import 'photo.dart';

class FuturePhotosListView extends StatefulWidget {
  const FuturePhotosListView({Key? key}) : super(key: key);

  @override
  State<FuturePhotosListView> createState() => _FuturePhotosListViewState();
}

class _FuturePhotosListViewState extends State<FuturePhotosListView> {
  late Future<List<Photo>> futurePhotosList;
  final photoService = PhotoService();

  @override
  void initState() {
    super.initState();
    futurePhotosList = photoService.fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Photo>>(
      future: futurePhotosList,
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return const Center(
            child: Text('An error has occurred!'),
          );
        }else if(snapshot.hasData){
          return PhotosListView(photos: snapshot.data!);
        }else{
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class PhotosListView extends StatelessWidget {
  final List<Photo> photos;

  const PhotosListView({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return Image.network(photos[index].thumbnailUrl);
        }
    );
  }
}