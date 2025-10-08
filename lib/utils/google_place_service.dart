// services/google_places_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class GooglePlacesService {
  final String apiKey;

  GooglePlacesService(this.apiKey);

  Future<List<Map<String, dynamic>>> getAutocomplete(String input) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&components=country:in';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      return List<Map<String, dynamic>>.from(data['predictions']);
    } else {
      throw Exception(data['error_message'] ?? 'Failed to fetch predictions');
    }
  }

  Future<Map<String, double>> getLatLngFromPlaceId(String placeId) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      final loc = data['result']['geometry']['location'];
      return {'lat': loc['lat'], 'lng': loc['lng']};
    } else {
      throw Exception(data['error_message'] ?? 'Failed to get place details');
    }
  }
}
