import 'package:flutter/material.dart';

import '../../services/history_service.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  List<Map<String, String>> _transactions = [];
  List<Map<String, String>> _systemUpdates = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);
    final t = await HistoryService.getTransactions();
    final s = await HistoryService.getSystemUpdates();
    setState(() {
      _transactions = t;
      _systemUpdates = s;
      _loading = false;
    });
  }

  Widget _buildCard(Map<String, String> item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.access_time, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['date'] ?? '',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['title'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if ((item['desc'] ?? '').isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      item['desc'] ?? '',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final combined = [..._transactions, ..._systemUpdates];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadAll,
        child: _loading
            ? ListView(children: const [SizedBox(height: 200, child: Center(child: CircularProgressIndicator()))])
            : combined.isEmpty
                ? ListView(
                    padding: const EdgeInsets.all(16),
                    children: const [Center(child: Text('Belum ada riwayat'))],
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: combined.map(_buildCard).toList(),
                  ),
      ),
    );
  }
}
