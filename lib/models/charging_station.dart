class ChargingStation {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  ChargingStation({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory ChargingStation.fromJson(Map<String, dynamic> json) {
    return ChargingStation(
      id: json['id'].toString(),
      name: json['name'] ?? json['title'] ?? 'No name',
      address: json['address'] ?? 'No address',
      latitude: (json['latitude'] ?? json['lat'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? json['lon'] ?? json['lng'] ?? 0).toDouble(),
    );
  }
}
