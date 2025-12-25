import 'package:flutter/material.dart';
import '../../screens/katalog/katalog_detail_page.dart';

class KatalogPage extends StatelessWidget {
  const KatalogPage({super.key});

  final List<Map<String, String>> cars = const [
    {'name': 'Honda Civic', 'price': 'Rp 450.000/hari', 'icon': '🚗'},
    {'name': 'Toyota Avanza', 'price': 'Rp 350.000/hari', 'icon': '🚙'},
    {'name': 'Suzuki Ertiga', 'price': 'Rp 400.000/hari', 'icon': '🚐'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Katalog Mobil'),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[300]!, Colors.blue[400]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Text('🗺️', style: TextStyle(fontSize: 80)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jarak Perjalanan',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '12 Km',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: Size(double.infinity, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Lihat Peta', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          ...cars.map((car) => Card(
                margin: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Text(car['icon']!, style: TextStyle(fontSize: 40)),
                  title: Text(
                    car['name']!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(car['price']!),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KatalogDetailPage(car: car),
                      ),
                    );
                  },
                ),
              )),
        ],
      ),
    );
  }
}
