import 'package:flutter/material.dart';
import 'photo/photosListView.dart';
import 'album/albumListView.dart';

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

  @override
  void initState(){
    super.initState();
  }

  Widget getWidget(){
    if(_selectedIndex == 0){
      return const FutureAlbumListView();
    }else{
      return const FuturePhotosListView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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