import 'package:app/apis/services/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentButton extends StatefulWidget {
  final int? initialAmount;
  final bool showAmountField;
  final String buttonText;
  final Color buttonColor;
  final Function? onPaymentSuccess;
  final Function? onPaymentError;

  const PaymentButton({
    Key? key,
    this.initialAmount,
    this.showAmountField = true,
    this.buttonText = 'Pay Now',
    this.buttonColor = Colors.blue,
    this.onPaymentSuccess,
    this.onPaymentError,
  }) : super(key: key);

  @override
  State<PaymentButton> createState() => _PaymentButtonState();
}

class _PaymentButtonState extends State<PaymentButton> {
  final TextEditingController _amountController = TextEditingController();
  final PaymentService _paymentService = PaymentService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialAmount != null) {
      _amountController.text = widget.initialAmount.toString();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // Launch URL within the app
  Future<void> _launchUrlInApp(String url) async {
    final Uri urlParsed = Uri.parse(url);
    if (!await launchUrl(urlParsed)) {
      throw Exception('Could not launch $url');
    }
  }

  // Handle payment process
  Future<void> _handlePayment() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final int? amount = widget.showAmountField
          ? int.tryParse(_amountController.text)
          : widget.initialAmount;

      if (amount == null || amount <= 0) {
        _showError("Please enter a valid amount.");
        return;
      }

      final response = await _paymentService.getPaymentLink(amount);
      final String paymentUrl = response["data"]["url"];

      if (paymentUrl.isNotEmpty) {
        await _launchUrlInApp(paymentUrl);
        if (widget.onPaymentSuccess != null) {
          widget.onPaymentSuccess!();
        }
      } else {
        _showError("Failed to retrieve payment link.");
      }
    } catch (e) {
      _showError("An error occurred: $e");
      if (widget.onPaymentError != null) {
        widget.onPaymentError!(e);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showAmountField) ...[
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Enter amount (VND)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
        ],
        ElevatedButton(
          onPressed: _isLoading ? null : _handlePayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.buttonColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: _isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : Text(widget.buttonText),
        ),
      ],
    );
  }
}