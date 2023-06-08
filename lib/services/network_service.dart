import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/dto/pokemon_dto.dart';
import 'package:pokedex/errors/network_error.dart';
import 'package:pokedex/models/pokemon_response.dart';

class NetworkService {
  static String baseURL = "pokeapi.co";
  static String basePath = "api/v2/pokemon";
  static String abilityPath = "api/v2/ability";

//****************************************************************************
//****************************************************************************

  Future<PokemonResponse> getPokemonsURLList(
      {required int limit, int? offset}) async {
    final url = Uri.https(
      baseURL,
      basePath,
      {
        "offset": offset.toString(),
        "limit": limit.toString(),
      },
    );

    final response = await http.get(url);

    if (response.statusCode < 200 || response.statusCode > 299) {
      throw NetworkError(response.statusCode, response.reasonPhrase);
    }

    final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return PokemonResponse.fromJson(decodedResponse);
  }

//****************************************************************************
//****************************************************************************

  Future<PokemonDTO> getPokemon({required String url}) async {
    final uri = Uri.parse(url);

    final response = await http.get(uri);

    if (response.statusCode < 200 || response.statusCode > 299) {
      throw NetworkError(response.statusCode, response.reasonPhrase);
    }

    final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;

    return PokemonDTO.fromJson(decodedResponse);
  }

//****************************************************************************
//****************************************************************************

  Future<Uint8List?> getPokemonImage(String imageURL) async {
    final url = Uri.parse(imageURL);
    final response = await http.get(url);

    if (response.statusCode < 200 || response.statusCode > 299) {
      return null;
    }

    final imageData = response.bodyBytes;
    return imageData;
  }

  //****************************************************************************
//****************************************************************************

  Future<String?> getPokemonAbility(int id) async {
    final url = Uri.https(
      baseURL,
      "$abilityPath/${id.toString()}/",
    );

    final response = await http.get(url);

    if (response.statusCode < 200 || response.statusCode > 299) {
      return null;
    }
    final decodedResponse = json.decode(response.body);

    return (decodedResponse["effect_entries"] as List<dynamic>)[1]["effect"];
  }
}
