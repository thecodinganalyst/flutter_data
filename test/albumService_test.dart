import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_data/album/albumService.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:flutter_data/album/album.dart';

import 'albumService_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('fetchAlbum', () {
    test('returns an Album if the http call completes successfully', () async {
      final client = MockClient();
      when(client.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async => http.Response('{"id": 1, "title": "mock"}', 200));
      var albumService = AlbumService();
      expect(await albumService.fetchAlbum(client, 1), isA<Album>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();
      when(client.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      var albumService = AlbumService();
      expect(albumService.fetchAlbum(client, 1), throwsException);
    });
  });
}