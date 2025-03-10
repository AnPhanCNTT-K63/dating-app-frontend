import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(6, (index) => FocusNode());
    _controllers = List.generate(6, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            // Nút back (mũi tên) ở góc trên cùng bên trái
            Positioned(
              top: 40,
              left: 16,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.grey,
                ),
                onPressed: () {
                  context.pop(); // Quay lại trang trước (NumberScreen)
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
                    const SizedBox(height: 60), // Để lại khoảng trống cho nút back
                    const Text(
                      'My code is',
                      style: TextStyle(
                        fontSize: 28, // Giảm kích thước tiêu đề
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 6 ô nhập mã OTP có gạch chân, nhỏ gọn hơn
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        return Container(
                          width: 36, // Giảm chiều rộng ô nhập
                          margin: const EdgeInsets.symmetric(horizontal: 4), // Giảm khoảng cách giữa các ô
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1, // Giới hạn 1 ký tự mỗi ô
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép số
                            ],
                            decoration: const InputDecoration(
                              counterText: '', // Ẩn bộ đếm ký tự
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1.5, // Giảm độ dày gạch chân
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 20, // Giảm kích thước chữ
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            onChanged: (value) {
                              if (value.length == 1 && index < 5) {
                                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                              } else if (value.isEmpty && index > 0) {
                                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                              }
                              setState(() {}); // Cập nhật giao diện
                            },
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 30),
                    // Nút CONTINUE
                    ElevatedButton(
                      onPressed: () {
                        final code = _controllers.map((c) => c.text).join();
                        if (code.length == 6) {
                          // Thêm logic xử lý khi mã đủ 6 chữ số
                          print('Mã nhập vào: $code');
                          context.go('/profile');// điều hướng qua trang profile
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: _controllers.every((c) => c.text.isNotEmpty)
                            ? const Color(0xFFF28C82) // Màu hồng cam khi đủ 6 số
                            : Colors.grey[200], // Màu xám nhạt khi chưa đủ
                        foregroundColor: _controllers.every((c) => c.text.isNotEmpty)
                            ? Colors.white
                            : Colors.black,
                        minimumSize: const Size(180, 45), // Giảm kích thước nút
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      child: const Text(
                        'CONTINUE',
                        style: TextStyle(
                          fontSize: 14, // Giảm kích thước chữ
                          fontWeight: FontWeight.bold,
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
