class PaymentService {
  static Future<bool> purchaseGoldTokens(int amount, double cost) async {
    // Demo: always succeed
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  static Future<bool> subscribeToPlan(String planId) async {
    // Demo: always succeed
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}