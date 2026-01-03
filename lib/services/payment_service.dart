class PaymentService {
  /// Returns a list of available payment methods (mocked)
  static Future<List<Map<String, String>>> getMethods() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      {'id': 'bank_bca', 'name': 'Transfer Bank BCA', 'desc': 'Virtual account / transfer bank'},
      {'id': 'gopay', 'name': 'GoPay', 'desc': 'E-wallet GoPay'},
      {'id': 'ovo', 'name': 'OVO', 'desc': 'E-wallet OVO'},
      {'id': 'card', 'name': 'Kartu Kredit', 'desc': 'Visa / MasterCard'},
    ];
  }

  /// Simulates processing a payment. Returns true on success.
  static Future<bool> processPayment({required String methodId, required int amount}) async {
    await Future.delayed(const Duration(seconds: 1));
    if (amount <= 0) return false;

    // In a real app, call your payment gateway here and return success/failure
    return true;
  }
}
