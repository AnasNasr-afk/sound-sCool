// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../business_logic/homeCubit/home_cubit.dart';
// import '../../business_logic/homeCubit/home_states.dart';
//
// class DebugInfoWidget extends StatelessWidget {
//   const DebugInfoWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeCubit, HomeStates>(
//       builder: (context, state) {
//         final cubit = HomeCubit.get(context);
//
//         return Positioned(
//           top: 40.h,
//           left: 20.w,
//           right: 20.w,
//           child: Container(
//             padding: EdgeInsets.all(12.w),
//             decoration: BoxDecoration(
//               color: Colors.black87,
//               borderRadius: BorderRadius.circular(8.r),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   '🔍 DEBUG INFO',
//                   style: TextStyle(
//                     color: Colors.yellow,
//                     fontSize: 12.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 4.h),
//                 Text(
//                   'Current State: ${state.runtimeType}',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 10.sp,
//                   ),
//                 ),
//                 Text(
//                   'Is Recording: ${cubit.isRecording}',
//                   style: TextStyle(
//                     color: cubit.isRecording ? Colors.red : Colors.green,
//                     fontSize: 10.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 if (state is SpeechTimerTickState)
//                   Text(
//                     'Timer: ${state.formattedTime}',
//                     style: TextStyle(
//                       color: Colors.orange,
//                       fontSize: 10.sp,
//                     ),
//                   ),
//                 if (cubit.displayedText != null)
//                   Text(
//                     'Has Text: YES',
//                     style: TextStyle(
//                       color: Colors.cyan,
//                       fontSize: 10.sp,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }