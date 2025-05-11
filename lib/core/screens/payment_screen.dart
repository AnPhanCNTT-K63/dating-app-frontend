import 'package:app/widgets/payment_button_widget.dart';
import 'package:flutter/material.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({Key? key}) : super(key: key);

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  void _onPaymentSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment initiated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _onPaymentError(dynamic error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment error: $error'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Make a Payment',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              // Using the PaymentButton widget
              PaymentButton(
                buttonText: 'Process Payment',
                buttonColor: Theme.of(context).primaryColor,
                onPaymentSuccess: _onPaymentSuccess,
                onPaymentError: _onPaymentError,
              ),
            ],
          ),
        ),
      ),
    );
  }
}