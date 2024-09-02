import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:http/http.dart';
import 'package:marvel/models/character.dart';
import 'package:marvel/models/serie.dart';
import 'dart:convert' as convert;
import 'package:marvel/services/api/http_basic_client.dart';

class SerieServiceAPI {
  final String url = "http://gateway.marvel.com";
  final String path = '/v1/public';
  final HttpBaseClient httpBaseClient = HttpBaseClient();

  SerieServiceAPI() {
    httpBaseClient.defaultHeaders = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  Future<List<Serie>> list(int characterId) async {
    try {
      Uri uri = Uri.parse(url);
      final Response response = await httpBaseClient.get(
        uri,
        path: "$path/characters/$characterId/series",
      );
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> body =
            Map<String, dynamic>.from(convert.jsonDecode(response.body));
        List<Map<String, dynamic>> result =
            List<Map<String, dynamic>>.from(body["data"]["results"]);
        return Serie.fromJsonList(result);
      }
      return [];
    } catch (e) {
      return Future.error(e);
    }
  }

  // /v1/public/series/{seriesId}/characters

  Future<List<Character>> get(int serieId) async {
    try {
      Uri uri = Uri.parse(url);
      final Response response = await httpBaseClient.get(
        uri,
        path: "$path/series/$serieId/characters",
      );
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> body =
            Map<String, dynamic>.from(convert.jsonDecode(response.body));
        List<Map<String, dynamic>> result =
            List<Map<String, dynamic>>.from(body["data"]["results"]);
        return Character.fromJsonList(result);
      }
      return [];
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<Character>> listRelatedCharactesBySeries(
    List<int> series, {
    int? characterSelected,
  }) async {
    try {
      List<Future> futures = [];
      for (int serie in series) {
        futures.add(get(serie));
      }

      List results = await Future.wait(futures);
      Set<Character> charactes = results.fold<Set<Character>>({}, (acc, list) {
        return {...acc, ...list};
      });

      return charactes.toList();
    } catch (e) {
      return Future.error(e);
    }
  }
}
