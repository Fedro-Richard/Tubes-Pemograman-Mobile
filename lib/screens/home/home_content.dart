import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/charging_station.dart';
import '../../services/station_service.dart';
import 'station_detail_page.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final MapController _mapController = MapController();
  LatLng? _userPosition;
  final double _userZoom = 14.0;

  @override
  void initState() {
    super.initState();
    _determinePositionAndMaybeCenter(center: false);
  }

  Future<bool> _determinePositionAndMaybeCenter({bool center = false}) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;

    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _userPosition = LatLng(pos.latitude, pos.longitude);
    });

    if (center && _userPosition != null) {
      _mapController.move(_userPosition!, _userZoom);
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, John',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Mau cari kendaraan apa?',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Cari kendaraan...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SizedBox(
                    height: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: FutureBuilder<List<ChargingStation>>(
                        future: StationService.fetchDummyStations(), // swap to fetchStations() for real API
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('No stations found'));
                          }

                          final stations = snapshot.data!;
                          final center = LatLng(stations[0].latitude, stations[0].longitude);

                          return Stack(
                            children: [
                              FlutterMap(
                                mapController: _mapController,
                                options: MapOptions(
                                  initialCenter: center,
                                  initialZoom: 13.0,
                                  interactionOptions: InteractionOptions(
                                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                                  ),
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.evrent.app',
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      ...stations.map((s) => Marker(
                                            point: LatLng(s.latitude, s.longitude),
                                            width: 40,
                                            height: 40,
                                            child: GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: Text(s.name),
                                                    content: Text(s.address),
                                                    actions: [
                                                      TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
                                                      ElevatedButton(onPressed: () {
                                                        Navigator.of(context).pop();
                                                        Navigator.of(context).push(
                                                          MaterialPageRoute(builder: (_) => StationDetailPage(station: s)),
                                                        );
                                                      }, child: const Text('View')),
                                                    ],
                                                  ),
                                                );
                                              },
                                              child: const Icon(Icons.ev_station, color: Colors.green, size: 36),
                                            ),
                                          )),
                                      if (_userPosition != null)
                                        Marker(
                                          point: _userPosition!,
                                          width: 28,
                                          height: 28,
                                          child: const Icon(Icons.my_location, color: Colors.blue, size: 28),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
