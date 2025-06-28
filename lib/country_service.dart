import 'package:chat/country_model.dart';
import 'package:dio/dio.dart';

class CountryService {
  final Dio _dio = Dio();

  Future<List<String>> fetchCountries() async {
    final response = await _dio.get(
      'https://restcountries.com/v3.1/all?fields=name,flags',
    );
    final List countries = response.data;
    return countries.map<String>((c) => c['name']['common'] as String).toList();
  }
  //  Future<List<Country>> fetchCountriess() async {
  //     try {
  //       final response = await _dio.get('https://restcountries.com/v3.1/all');

  //       if (response.statusCode == 200) {
  //         List<dynamic> data = response.data;
  //         return data.map((json) => Country.fromJson(json)).toList();
  //       } else {
  //         throw Exception('Failed to load countries');
  //       }
  //     } catch (e) {
  //       throw Exception('Country fetch error: $e');
  //     }
  //   }
  Future<List<Country>> fetchCountriess() async {
    try {
      final response = await _dio.get(
        'https://restcountries.com/v3.1/all?fields=name,flags',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        final List<Country> countries = data.map((json) {
          return Country.fromJson(json as Map<String, dynamic>);
        }).toList();

        return countries;
      } else {
        throw Exception('Failed to load countries');
      }
    } catch (e) {
      throw Exception('Country fetch error: $e');
    }
  }
}
