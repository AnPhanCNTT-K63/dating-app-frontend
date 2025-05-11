
import 'package:app/apis/api_service.dart';

class PaymentService {
  final _apiService = ApiService();

  Future<Map<String, dynamic>> getPaymentLink(int amount) async {
    final response = await _apiService.get(
      "payment/create-vnpay-url",
      queryParams: {
        'amount': amount,
      },
    );
    return response;
  }

}