import 'package:flutter/material.dart';
import '../../services/payment_service.dart';
import '../../services/history_service.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, String> car;
  final int amount; // amount in smallest currency unit (here: plain integer for simplicity)

  const PaymentPage({super.key, required this.car, required this.amount});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List<Map<String, String>> _methods = [];
  String? _selectedMethodId;
  bool _processing = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMethods();
  }

  Future<void> _loadMethods() async {
    setState(() => _loading = true);
    try {
      final m = await PaymentService.getMethods();
      setState(() {
        _methods = m;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _methods = [];
        _loading = false;
      });
    }
  }

  Future<void> _pay() async {
    if (_selectedMethodId == null) return;
    setState(() => _processing = true);
    final success = await PaymentService.processPayment(
      methodId: _selectedMethodId!,
      amount: widget.amount,
    );
    setState(() => _processing = false);

    if (success) {
      try {
        final now = DateTime.now();
        final dateStr = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
        await HistoryService.addTransaction(name: widget.car['name'] ?? 'Kendaraan', amount: widget.amount, date: dateStr);
        await HistoryService.addSystemUpdate(
            date: dateStr,
            title: 'Pembaharuan Sistem',
            desc: 'Transaksi untuk ${widget.car['name']} berhasil tercatat pada $dateStr.');
      } catch (_) {}
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(success ? 'Pembayaran Berhasil' : 'Pembayaran Gagal'),
        content: Text(success
            ? 'Terima kasih! Pembayaran berhasil. Transaksi untuk ${widget.car['name']} telah berhasil.'
            : 'Terjadi kesalahan saat memproses pembayaran.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (success) Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatAmount(int amount) {
    // naive formatting: 700000 -> "Rp 700.000"
    final s = amount.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count % 3 == 0 && i != 0) buffer.write('.');
    }
    return 'Rp ' + buffer.toString().split('').reversed.join('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Metode Pembayaran')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Text(widget.car['icon'] ?? '🚗', style: const TextStyle(fontSize: 36)),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.car['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(_formatAmount(widget.amount), style: const TextStyle(color: Colors.green)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Pilih Metode Pembayaran:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (_loading) const Expanded(child: Center(child: CircularProgressIndicator())),
            if (!_loading && _methods.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Tidak ada metode pembayaran', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 12),
                      ElevatedButton(onPressed: _loadMethods, child: const Text('Muat Ulang')),
                    ],
                  ),
                ),
              ),
            if (!_loading && _methods.isNotEmpty)
              Expanded(
                child: ListView(
                  children: _methods
                      .map((m) => RadioListTile<String>(
                            value: m['id']!,
                            groupValue: _selectedMethodId,
                            onChanged: (v) => setState(() => _selectedMethodId = v),
                            title: Text(m['name']!),
                            subtitle: Text(m['desc']!),
                          ))
                      .toList(),
                ),
              ),
            ElevatedButton(
              onPressed: (_selectedMethodId == null || _processing) ? null : _pay,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: _processing ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text('Bayar ${_formatAmount(widget.amount)}'),
            ),
          ],
        ),
      ),
    );
  }
}
