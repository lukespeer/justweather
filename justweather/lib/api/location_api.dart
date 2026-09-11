import 'dart:convert';

import 'package:http/http.dart' as http;

class City {
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? state;

  City({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.state,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      country: json['country'],
      state: json['admin1'],
    );
  }
}

Future<List<City>> searchCities(String search) async {
  if (search.trim().isEmpty) {
    return [];
  }

  final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
    'name': search,
    'count': '10',
    'language': 'en',
    'format': 'json',
  });

  final response = await http.get(uri);

  if (response.statusCode != 200) {
    throw Exception('Failed to search cities');
  }

  final data = jsonDecode(response.body);

  if (data['results'] == null) {
    return [];
  }

  return (data['results'] as List).map((json) => City.fromJson(json)).toList();
}
