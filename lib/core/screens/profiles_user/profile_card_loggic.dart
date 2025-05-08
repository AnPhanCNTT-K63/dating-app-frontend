// import 'package:flutter/material.dart';
//
// // Class chứa thông tin người dùng
// class UserProfile {
//   final String name;
//   final int age;
//   final String location;
//   final String distance;
//   final String photoUrl;
//
//   // Constructor yêu cầu đầy đủ thông tin hồ sơ
//   UserProfile({
//     required this.name,
//     required this.age,
//     required this.location,
//     required this.distance,
//     required this.photoUrl,
//   });
// }
//
// // Controller xử lý logic thẻ hồ sơ
// class ProfileCardController {
//   // Danh sách người dùng mẫu
//   final List<UserProfile> profiles = [
//     UserProfile(
//       name: "Maria",
//       age: 25,
//       location: "Lives in Lisbon",
//       distance: "2 kilometers away",
//       photoUrl: "assets/images/profile1.jpg",
//     ),
//     UserProfile(
//       name: "Paulo",
//       age: 29,
//       location: "Lives in Alfama",
//       distance: "1 kilometer away",
//       photoUrl: "assets/images/profile2.jpg",
//     ),
//     UserProfile(
//       name: "João",
//       age: 31,
//       location: "Lives in Porto",
//       distance: "5 kilometers away",
//       photoUrl: "assets/images/profile3.jpg",
//     ),
//   ];
//
//   int currentIndex = 0;  // Chỉ mục hồ sơ hiển thị hiện tại
//
//   // Lấy hồ sơ hiện tại
//   UserProfile get currentProfile => profiles[currentIndex];
//
//   // Lấy hồ sơ tiếp theo (nếu có)
//   UserProfile? get nextProfile {
//     if (currentIndex + 1 < profiles.length) {
//       return profiles[currentIndex + 1];
//     }
//     return null;
//   }
//
//   // Chuyển sang hồ sơ tiếp theo
//   void nextProfile() {
//     if (currentIndex < profiles.length - 1) {
//       currentIndex++;
//     } else {
//       currentIndex = 0; // Quay vòng về hồ sơ đầu tiên
//     }
//   }
//
//   // Xử lý khi người dùng vuốt phải (thích)
//   void handleLike() {
//     nextProfile();
//   }
//
//   // Xử lý khi người dùng vuốt trái (không thích)
//   void handleDislike() {
//     nextProfile();
//   }
//
//   // Xử lý khi nhấn nút super-like
//   void handleSuperLike() {
//     // Logic cho super-like có thể thêm ở đây
//     nextProfile();
//   }
//
//   // Xử lý khi nhấn nút rewind (quay lại)
//   void handleRewind() {
//     // Logic quay lại hồ sơ trước đó (cần lưu lịch sử)
//     // Thêm logic ở đây
//   }
//
//   // Xử lý khi nhấn nút boost
//   void handleBoost() {
//     // Logic boost hồ sơ
//     // Thêm logic ở đây
//   }
//
//   // Tạo các animator cho hiệu ứng thẻ
//   AnimationController createDragAnimationController(TickerProvider vsync) {
//     return AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: vsync,
//     );
//   }
//
//   // Tạo animation cho thẻ tiếp theo
//   AnimationController createNextCardAnimController(TickerProvider vsync) {
//     return AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: vsync,
//     );
//   }
//
//   // Tạo hiệu ứng scale cho thẻ tiếp theo
//   Animation<double> createNextCardScaleAnimation(AnimationController controller) {
//     return Tween<double>(begin: 0.9, end: 1.0).animate(
//         CurvedAnimation(parent: controller, curve: Curves.easeInOut)
//     );
//   }
//
//   // Tạo animation vuốt sang phải
//   void setupSwipeRightAnimation(
//       double startPosition,
//       AnimationController controller,
//       Animation<double> positionAnimation,
//       Animation<double> rotationAnimation
//       ) {
//     // Tạo animation vuốt sang phải
//     positionAnimation = Tween<double>(
//       begin: startPosition,
//       end: 500, // Di chuyển ra khỏi màn hình sang phải
//     ).animate(controller);
//
//     rotationAnimation = Tween<double>(
//       begin: startPosition * 0.002,
//       end: 0.3, // Xoay khi vuốt sang phải
//     ).animate(controller);
//   }
//
//   // Tạo animation vuốt sang trái
//   void setupSwipeLeftAnimation(
//       double startPosition,
//       AnimationController controller,
//       Animation<double> positionAnimation,
//       Animation<double> rotationAnimation
//       ) {
//     // Tạo animation vuốt sang trái
//     positionAnimation = Tween<double>(
//       begin: startPosition,
//       end: -500, // Di chuyển ra khỏi màn hình sang trái
//     ).animate(controller);
//
//     rotationAnimation = Tween<double>(
//       begin: startPosition * 0.002,
//       end: -0.3, // Xoay khi vuốt sang trái
//     ).animate(controller);
//   }
//
//   // Tạo animation quay lại vị trí ban đầu
//   void setupReturnAnimation(
//       double startPosition,
//       AnimationController controller,
//       Animation<double> positionAnimation,
//       Animation<double> rotationAnimation
//       ) {
//     // Tạo animation quay lại vị trí ban đầu
//     positionAnimation = Tween<double>(
//       begin: startPosition,
//       end: 0, // Trở về vị trí ban đầu
//     ).animate(
//         CurvedAnimation(parent: controller, curve: Curves.elasticOut)
//     );
//
//     rotationAnimation = Tween<double>(
//       begin: startPosition * 0.002,
//       end: 0, // Hết xoay
//     ).animate(
//         CurvedAnimation(parent: controller, curve: Curves.elasticOut)
//     );
//   }
// }