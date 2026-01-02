import 'package:flutter/material.dart';
import '../../screens/katalog/katalog_detail_page.dart';

import '../../models/charging_station.dart';

class StationDetailPage extends StatelessWidget {
  final ChargingStation station;

  const StationDetailPage({super.key, required this.station});

  // Dummy vehicles for each station; in real app fetch from API
  List<Map<String, String>> _vehiclesForStation(String stationId) {
    // Example: vary slightly by stationId
    if (stationId == '2') {
      return const [
        {'name': 'Nissan Leaf', 'price': 'Rp 300.000/hari', 'icon': '🔋'},
        {'name': 'Wuling Mini EV', 'price': 'Rp 200.000/hari', 'icon': '🚗'},
      ];
    }

    return const [
      {'name': 'Tesla Model 3', 'price': 'Rp 700.000/hari', 'icon': '🚗'},
      {'name': 'BMW i3', 'price': 'Rp 550.000/hari', 'icon': '🚙'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = _vehiclesForStation(station.id);

    return Scaffold(
      appBar: AppBar(title: Text(station.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(station.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(station.address, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.green),
                      const SizedBox(width: 8),
                      Text('Lat: ${station.latitude}, Lon: ${station.longitude}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Katalog Kendaraan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...vehicles.map((car) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Text(car['icon']!, style: const TextStyle(fontSize: 36)),
                  title: Text(car['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(car['price']!),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => KatalogDetailPage(car: car)),
                    );
                  },
                ),
              )),
        ],
      ),
    );
  }
}
