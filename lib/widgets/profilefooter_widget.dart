// import 'package:flutter/material.dart';

//
// class PlatinumWidget extends StatelessWidget {
//   const PlatinumWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               Icon(
//                 Icons.local_fire_department_rounded,
//                 color: Colors.black,
//                 size: 24,
//               ),
//               SizedBox(width: 8),
//               Text(
//                 'Tinder Platinum',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 10),
//           const Text(
//             'Level up every action you take on Tinder',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.black,
//             ),
//           ),
//
//           // Pagination dots
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 8,
//                 height: 8,
//                 decoration: const BoxDecoration(
//                   color: Colors.black,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               const SizedBox(width: 4),
//               ...List.generate(
//                 4,
//                     (index) => Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 2),
//                   width: 8,
//                   height: 8,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           // Learn more button
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//               elevation: 0,
//               side: BorderSide(color: Colors.grey.shade300),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
//             ),
//             child: const Text(
//               'LEARN MORE',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }