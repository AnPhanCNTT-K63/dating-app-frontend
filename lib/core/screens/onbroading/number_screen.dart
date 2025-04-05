import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class NumberScreen extends StatefulWidget {
  const NumberScreen({Key? key}) : super(key: key);

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  String countryCode = '+82';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            // Nút "<" ở góc trên cùng bên trái
            Positioned(
              top: 0,
              left: 0,
              child: IconButton(
                icon: const Text(
                  '<',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                onPressed: () {
                  context.go('/'); // Quay lại LoginScreen
                },
              ),
            ),
            // Nội dung chính
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60), // Để lại khoảng trống cho nút "<"
                    const Text(
                      'My number is',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                countryCode = '+1'; // Test change
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: Text(countryCode),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              autofocus: true, // Tự động hiện bàn phím
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: '00000000',
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.all(10),
                                prefix: Text(' $countryCode - '),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'We will send a text with a verification code.\nMessage and data rates may apply. Learn what\nhappens when your number changes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        context.push('/verification'); // Điều hướng đến VerificationScreen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF28C82),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text('CONTINUE'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}