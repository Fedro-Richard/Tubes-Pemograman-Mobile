import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/charging_station.dart';

class StationService {
  // TODO: replace with your real EVRent API endpoint
  static const String _baseUrl = 'https://example.com/api/charging_stations';

  static Future<List<ChargingStation>> fetchStations() async {
    final uri = Uri.parse(_baseUrl);
    final res = await http.get(uri);

    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((e) => ChargingStation.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load stations (${res.statusCode})');
    }
  }

  // Local dummy data for development/testing
  static Future<List<ChargingStation>> fetchDummyStations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      ChargingStation(
        id: '1',
        name: 'EVRent Station A',
        address: 'Jl. Contoh No.1',
        latitude: -6.234,
        longitude: 106.979,
      ),
      ChargingStation(
        id: '2',
        name: 'EVRent Station B',
        address: 'Jl. Contoh No.2',
        latitude: -6.235,
        longitude: 106.985,
      ),
    ];
  }
}
