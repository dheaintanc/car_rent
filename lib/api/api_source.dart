import 'dart:convert';

import 'package:car_rental/constants/car_rental_impl.dart';
import 'package:http/http.dart' as http;

class ApiSource {
  static const String baseUrl = 'https://freetestapi.com/api/v1/cars';

  Future<List<CarRents>> getCarRents() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> carRents = json.decode(response.body);
      return carRents.map((dynamic json) => CarRents.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load car rents');
    }
  }
}
