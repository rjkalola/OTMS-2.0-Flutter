import 'dart:convert';
import 'package:belcka/pages/profile/post_coder_search/model/post_coder_model.dart';
import 'package:http/http.dart' as http;

class PostCoderSearchRepository {
  Future<List<PostCoderModel>> getAddresses({
    required String postcode,
    required int page,
    required String countryCode,
  }) async {
    final url = Uri.parse(
      "${PostCoderApiConfig.baseUrl}/address/$countryCode/$postcode?page=$page",
    );

    final response = await http.get(url);

    print("RAW RESPONSE = ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data.map((e) => PostCoderModel.fromJson(e)).toList();
      } else {
        throw "invalidFormat";
      }
    } else if (response.statusCode == 404) {
      throw "noResultsFound";
    } else {
      throw "apiError";
    }
  }
}

class PostCoderApiConfig {
  static const String scheme = "https";
  static const String host = "ws.postcoder.com";
  static const String apiKey = "PCWNZ-GXWFW-NMB74-BQ8K5";

  static String get baseUrl {
    return "$scheme://$host/pcw/$apiKey";
  }
}