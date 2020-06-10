import 'dart:convert';
import 'dart:async';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {
  String _apikey = '00641535c7eaac6dcbb108870fe4cec2';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _popularesPage = 0;
  bool cargando = false;

  List<Pelicula> _listaPeliculasPopulares = new List();

  final _peliculasPopularesStreamController =
      new StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get peliculasPopularesSink =>
      _peliculasPopularesStreamController.sink.add;
  Stream<List<Pelicula>> get peliculasPopularesStream =>
      _peliculasPopularesStreamController.stream;

  void disposeStreams() {
    _peliculasPopularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);

    // print("Results: ${decodeData['results']}");

    Peliculas peliculas = new Peliculas.fromJsonList(decodeData['results']);

    // print("Peliculas length: ${peliculas.items.length}");
    // print("Pelicula 0: ${peliculas.items[8].title}");

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    _popularesPage++;

    // print('cargando value: $cargando');
    if (cargando) {
      // print('lista vacía');
      return [];
    }

    // print('Se va a realizar la carga y activar candado');
    cargando = true;
    // print('candado activado $cargando');

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    _listaPeliculasPopulares.addAll(resp);
    // print('Se llamo al endpoint');
    peliculasPopularesSink(resp);

    cargando = false;
    // print('candado desactivado $cargando');

    return resp;
  }

  Future<List<Actor>> getCats(int peliculaId) async {
    final url = Uri.https(_url, '3/movie/$peliculaId/credits',
        {'api_key': _apikey, 'language': _language});

    final resp = await http.get(url);

    final decodeData = json.decode(resp.body);

    final cast = Cast.fromJsonList(decodeData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apikey, 'language': _language, 'query': query});

    return await _procesarRespuesta(url);
  }
}
