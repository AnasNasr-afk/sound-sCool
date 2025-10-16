// // lib/presentation/screens/voice_records_history_screen.dart
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../data/models/voice_recording_model.dart';
// import '../../business_logic/homeCubit/home_cubit.dart';
// import '../../helpers/color_manager.dart';
// import '../../helpers/text_styles.dart';
//
// class VoiceRecordsHistoryScreen extends StatefulWidget {
//   final HomeCubit cubit;
//
//   const VoiceRecordsHistoryScreen({super.key, required this.cubit});
//
//   @override
//   State<VoiceRecordsHistoryScreen> createState() =>
//       _VoiceRecordsHistoryScreenState();
// }
//
// class _VoiceRecordsHistoryScreenState extends State<VoiceRecordsHistoryScreen> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   String? _playingRecordingId;
//   bool _isPlaying = false;
//
//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorManager.backgroundColor2,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios_new,
//             size: 18.w,
//             color: ColorManager.mainBlack,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Voice Records History',
//           style: TextStyles.font20BlackBold.copyWith(
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: false,
//       ),
//       body: StreamBuilder<List<VoiceRecordingModel>>(
//         stream: widget.cubit.getRecordingsStream(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: ColorManager.mainGreen,
//               ),
//             );
//           }
//
//           if (snapshot.hasError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.error_outline, size: 48.w, color: Colors.red),
//                   SizedBox(height: 16.h),
//                   Text('Error loading recordings',
//                       style: TextStyles.font16LightBlackSemiBold),
//                 ],
//               ),
//             );
//           }
//
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.mic_off,
//                       size: 64.w, color: ColorManager.darkGrey.withValues(alpha: 0.3)),
//                   SizedBox(height: 16.h),
//                   Text(
//                     'No recordings yet',
//                     style: TextStyles.font20BlackBold.copyWith(
//                       color: ColorManager.darkGrey,
//                     ),
//                   ),
//                   SizedBox(height: 8.h),
//                   Text(
//                     'Complete a session to save your first recording',
//                     style: TextStyles.font16LightBlackSemiBold.copyWith(
//                       color: ColorManager.darkGrey.withValues(alpha: 0.6),
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           return ListView.separated(
//             padding: EdgeInsets.all(20.w),
//             itemCount: snapshot.data!.length,
//             separatorBuilder: (context, index) => SizedBox(height: 12.h),
//             itemBuilder: (context, index) {
//               final recording = snapshot.data![index];
//               return _buildRecordingCard(recording);
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildRecordingCard(VoiceRecordingModel recording) {
//     final isPlaying = _playingRecordingId == recording.id && _isPlaying;
//
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         boxShadow: [
//           BoxShadow(
//             color: ColorManager.darkGrey.withValues(alpha: 0.1),
//             spreadRadius: 0,
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header with name and actions
//           Padding(
//             padding: EdgeInsets.all(16.w),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () => _showRenameDialog(recording),
//                     child: Row(
//                       children: [
//                         Flexible(
//                           child: Text(
//                             recording.name,
//                             style: TextStyles.font20BlackBold.copyWith(
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.w600,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         SizedBox(width: 6.w),
//                         Icon(
//                           Icons.edit,
//                           size: 14.w,
//                           color: ColorManager.darkGrey.withValues(alpha: 0.5),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.delete_outline, color: Colors.red),
//                   onPressed: () => _showDeleteDialog(recording),
//                 ),
//               ],
//             ),
//           ),
//
//           // Divider
//           Divider(height: 1, color: ColorManager.darkGrey.withValues(alpha: 0.1)),
//
//           // Info section
//           Padding(
//             padding: EdgeInsets.all(16.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     _buildInfoChip(
//                       icon: Icons.language,
//                       label: recording.language,
//                       color: ColorManager.mainGreen,
//                     ),
//                     SizedBox(width: 8.w),
//                     _buildInfoChip(
//                       icon: Icons.school,
//                       label: recording.level,
//                       color: Colors.blue,
//                     ),
//                     Spacer(),
//                     _buildScoreBadge(recording.accuracyScore),
//                   ],
//                 ),
//                 SizedBox(height: 12.h),
//                 Text(
//                   _formatDate(recording.createdAt),
//                   style: TextStyles.font16LightBlackSemiBold.copyWith(
//                     fontSize: 13.sp,
//                     color: ColorManager.darkGrey.withValues(alpha: 0.6),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Play button
//           Padding(
//             padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
//             child: SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: () => _togglePlayPause(recording),
//                 icon: Icon(
//                   isPlaying ? Icons.pause : Icons.play_arrow,
//                   size: 20.w,
//                 ),
//                 label: Text(isPlaying ? 'Pause' : 'Play Recording'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: isPlaying
//                       ? ColorManager.darkGrey
//                       : ColorManager.mainGreen,
//                   foregroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(vertical: 12.h),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           // Expandable details
//           ExpansionTile(
//             tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
//             title: Text(
//               'View Details',
//               style: TextStyles.font16LightBlackSemiBold.copyWith(
//                 fontSize: 14.sp,
//                 color: ColorManager.mainGreen,
//               ),
//             ),
//             children: [
//               Padding(
//                 padding: EdgeInsets.all(16.w),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildDetailSection(
//                       title: 'Generated Text',
//                       content: recording.generatedText,
//                     ),
//                     SizedBox(height: 12.h),
//                     _buildDetailSection(
//                       title: 'Your Recording',
//                       content: recording.recordedText,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoChip({
//     required IconData icon,
//     required String label,
//     required Color color,
//   }) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(8.r),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14.w, color: color),
//           SizedBox(width: 4.w),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12.sp,
//               color: color,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildScoreBadge(double score) {
//     Color color = score >= 80
//         ? ColorManager.mainGreen
//         : score >= 60
//         ? Colors.orange
//         : Colors.red;
//
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: 0.15),
//         borderRadius: BorderRadius.circular(20.r),
//         border: Border.all(color: color, width: 1.5),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.star, size: 14.w, color: color),
//           SizedBox(width: 4.w),
//           Text(
//             '${score.toStringAsFixed(0)}%',
//             style: TextStyle(
//               fontSize: 13.sp,
//               color: color,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailSection({required String title, required String content}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyles.font16LightBlackSemiBold.copyWith(
//             fontSize: 13.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         SizedBox(height: 6.h),
//         Container(
//           width: double.infinity,
//           padding: EdgeInsets.all(12.w),
//           decoration: BoxDecoration(
//             color: ColorManager.backgroundColor2,
//             borderRadius: BorderRadius.circular(8.r),
//           ),
//           child: Text(
//             content.isEmpty ? 'No text available' : content,
//             style: TextStyles.font16LightBlackSemiBold.copyWith(
//               fontSize: 14.sp,
//               color: content.isEmpty
//                   ? ColorManager.darkGrey.withValues(alpha: 0.5)
//                   : ColorManager.mainBlack,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   String _formatDate(DateTime date) {
//     final now = DateTime.now();
//     final difference = now.difference(date);
//
//     if (difference.inDays == 0) {
//       return 'Today at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
//     } else if (difference.inDays == 1) {
//       return 'Yesterday at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
//     } else if (difference.inDays < 7) {
//       return '${difference.inDays} days ago';
//     } else {
//       return '${date.day}/${date.month}/${date.year}';
//     }
//   }
//
//   Future<void> _togglePlayPause(VoiceRecordingModel recording) async {
//     try {
//       if (_playingRecordingId == recording.id && _isPlaying) {
//         await _audioPlayer.pause();
//         setState(() => _isPlaying = false);
//       } else {
//         await _audioPlayer.play(UrlSource(recording.audioUrl));
//         setState(() {
//           _playingRecordingId = recording.id;
//           _isPlaying = true;
//         });
//       }
//
//       _audioPlayer.onPlayerComplete.listen((_) {
//         setState(() => _isPlaying = false);
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error playing audio: $e')),
//       );
//     }
//   }
//
//   void _showRenameDialog(VoiceRecordingModel recording) {
//     final controller = TextEditingController(text: recording.name);
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Rename Recording'),
//         content: TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             hintText: 'Enter new name',
//             border: OutlineInputBorder(),
//           ),
//           autofocus: true,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (controller.text.trim().isNotEmpty) {
//                 widget.cubit.updateRecordingName(
//                   recording.id,
//                   controller.text.trim(),
//                 );
//                 Navigator.pop(context);
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: ColorManager.mainGreen,
//             ),
//             child: Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showDeleteDialog(VoiceRecordingModel recording) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Delete Recording'),
//         content: Text('Are you sure you want to delete "${recording.name}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               widget.cubit.deleteRecording(recording.id, recording.storagePath);
//               Navigator.pop(context);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//             ),
//             child: Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }
// }