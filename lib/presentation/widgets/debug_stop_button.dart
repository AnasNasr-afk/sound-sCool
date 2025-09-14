// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../business_logic/homeCubit/home_cubit.dart';
// import '../../business_logic/homeCubit/home_states.dart';
//
// class DebugStopButton extends StatelessWidget {
//   const DebugStopButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeCubit, HomeStates>(
//       builder: (context, state) {
//         final cubit = HomeCubit.get(context);
//
//         // Only show this button when actually recording
//         if (state is SpeechListeningState || state is SpeechTimerTickState) {
//           return Positioned(
//             top: 100.h,
//             right: 20.w,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.circular(8.r),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.red.withValues(alpha: 0.3),
//                     blurRadius: 8.r,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   borderRadius: BorderRadius.circular(8.r),
//                   onTap: () {
//                     debugPrint("🔴 DEBUG: Manual stop button pressed");
//                     debugPrint("🔴 DEBUG: Current state: ${state.runtimeType}");
//                     debugPrint("🔴 DEBUG: Is recording: ${cubit.isRecording}");
//
//                     // Force stop recording
//                     cubit.stopRecording();
//                   },
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 12.w,
//                       vertical: 8.h,
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           Icons.stop,
//                           color: Colors.white,
//                           size: 16.sp,
//                         ),
//                         SizedBox(width: 4.w),
//                         Text(
//                           'STOP',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }
//
//         return const SizedBox.shrink();
//       },
//     );
//   }
// }