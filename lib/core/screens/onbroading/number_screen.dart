import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_decoration.dart';
import '../../theme/app_theme.dart';


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
                  context.go('/');
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
                    const SizedBox(height: 60), // khoảng trống cho nút "<"
                    Text(
                      'My number is',
                      style: AppTheme.titleLarge20.copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                countryCode = '+1'; // test change
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: Text(
                              countryCode,
                              style: AppTheme.bodyMedium14.copyWith(color: Colors.black),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              autofocus: true,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: '00000000',
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.all(10),
                                prefix: Text(' $countryCode - '),
                              ),
                              style: AppTheme.bodyMedium14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'We will send a text with a verification code.\nMessage and data rates may apply. Learn what\nhappens when your number changes.',
                      textAlign: TextAlign.center,
                      style: AppTheme.bodySmall12.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 40),

                    // ✅ Nút CONTINUE với gradient, border, font chữ đẹp
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        onTap: () {
                          context.push('/verification');
                        },
                        child: Container(
                          width: 200,
                          height: 50,
                          decoration: AppDecoration.createAccountButton(),
                          alignment: Alignment.center,
                          child: Text(
                            'CONTINUE',
                            style: AppTheme.titleSmall16.copyWith(
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
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
