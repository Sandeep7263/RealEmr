import 'package:http/http.dart' as http;
import 'dart:convert';

class YourApiService {
  static final String apiKey = 'AIzaSyDmWPgrLw43gcRU7hYVS34yleVTd9O5a0g';

  static Future<List<String>> fetchStates() async {
    try {
      final response = await http.get(
          'https://maps.googleapis.com/maps/api/geocode/json?address=country=India&key=$apiKey' as Uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<String> states = [];
        // Parsing the response to extract state names
        if (data['results'] != null) {
          for (var result in data['results']) {
            var addressComponents = result['address_components'];
            for (var component in addressComponents) {
              var types = component['types'];
              if (types.contains('administrative_area_level_1')) {
                states.add(component['long_name']);
              }
            }
          }
        }
        return states.toSet().toList(); // Returning unique state names
      } else {
        throw Exception('Failed to fetch states');
      }
    } catch (e) {
      throw Exception('Failed to fetch states: $e');
    }
  }

  static Future<List<String>> fetchCities(String selectedState) async {
    try {
      final response = await http.get(
          'https://maps.googleapis.com/maps/api/geocode/json?address=$selectedState&key=$apiKey' as Uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<String> cities = [];
        // Parsing the response to extract city names based on the selected state
        if (data['results'] != null) {
          for (var result in data['results']) {
            var addressComponents = result['address_components'];
            for (var component in addressComponents) {
              var types = component['types'];
              if (types.contains('locality')) {
                cities.add(component['long_name']);
              }
            }
          }
        }
        return cities.toSet().toList(); // Returning unique city names
      } else {
        throw Exception('Failed to fetch cities');
      }
    } catch (e) {
      throw Exception('Failed to fetch cities: $e');
    }
  }
}
