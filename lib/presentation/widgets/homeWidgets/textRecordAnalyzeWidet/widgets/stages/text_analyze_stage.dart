import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/helpers/text_styles.dart';
import 'package:sounds_cool/presentation/widgets/homeWidgets/textRecordAnalyzeWidet/widgets/components/secondary_action_button.dart';

import '../../../../../../business_logic/homeCubit/home_cubit.dart';
import '../../../../../../business_logic/homeCubit/home_states.dart';
import '../../../../../../helpers/color_manager.dart';

class TextAnalyzeStage extends StatelessWidget {
  const TextAnalyzeStage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final cubit = HomeCubit.get(context);

        String original = cubit.displayedText ?? "";
        String recorded = cubit.finalRecordedText ?? "";

        final analysis = _analyze(original, recorded);

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TITLE
              Text(
                "Your Result",
                style: TextStyles.font14DarkGreyRegular.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                  color: ColorManager.mainBlack,
                ),
              ),
              SizedBox(height: 10.h),

              // ACCURACY CARD
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${analysis.accuracy.toStringAsFixed(0)}%",
                      style: TextStyles.font30BlackSemiBold.copyWith(
                        color: _accuracyColor(analysis.accuracy),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${analysis.correct} correct",
                          style: TextStyles.font10BlackSemiBold.copyWith(
                            // fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          "${analysis.missed} missed",
                          style: TextStyles.font10BlackSemiBold.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 18.h),

              // MISSED WORDS
              if (analysis.missedWords.isNotEmpty) ...[
                Text(
                  "Words to Practice",
                  style: TextStyles.font14DarkGreyRegular.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                    color: ColorManager.mainBlack,
                  ),
                ),
                SizedBox(height: 10.h),

                // Wrap with compact chips
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: analysis.missedWords.map((w) {
                    return _compactWordChip(w);
                  }).toList(),
                ),
              ],

              SizedBox(height: 20.h),

              // ACTION BUTTONS (smaller)
              Row(
                children: [
                  Expanded(
                    child: SecondaryActionButton(
                      onPressed: () {
                        cubit.goToStage(Stage.record);
                      },
                      label: 'Try Again',
                      icon: Icons.refresh,
                      backgroundColor: Colors.transparent,
                      borderColor: ColorManager.mainGreen,
                      textColor: ColorManager.mainBlack,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: SecondaryActionButton(
                      onPressed: () async {
                        await cubit.completeSession();
                        cubit.goToStage(Stage.generate);

                      Flushbar(
                          messageText: Text(
                            'Session completed successfully!',
                            textAlign: TextAlign.center,
                            style: TextStyles.font14GreyRegular.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          margin: EdgeInsets.all(16),
                          borderRadius: BorderRadius.circular(12),
                          backgroundColor: Colors.green,
                          flushbarPosition: FlushbarPosition.TOP,
                          duration: Duration(seconds: 2),
                          boxShadows: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          animationDuration: Duration(milliseconds: 300),
                        ).show(context);
                      },
                      label: 'Done',
                      backgroundColor: ColorManager.mainGreen,
                      textColor: ColorManager.whiter,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Compact word chip: only as wide as its content
  Widget _compactWordChip(String word) {
    return Container(
      constraints: const BoxConstraints(minWidth: 0),
      // important for tight sizing
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        word,
        style: TextStyles.font10BlackSemiBold.copyWith(
          fontWeight: FontWeight.w500,
          color: Colors.red,
          fontSize: 11.sp,
        ),
      ),
    );
  }

  // SIMPLE TEXT ANALYSIS
  _Analysis _analyze(String original, String recorded) {
    List<String> o = _clean(original);
    List<String> r = _clean(recorded);

    int correct = 0;
    List<String> missed = [];

    for (var w in o) {
      if (r.contains(w.toLowerCase())) {
        correct++;
      } else {
        missed.add(w);
      }
    }

    double accuracy = o.isEmpty ? 0 : (correct / o.length) * 100;

    return _Analysis(
      accuracy: accuracy,
      correct: correct,
      missed: o.length - correct,
      missedWords: missed,
    );
  }

  List<String> _clean(String text) {
    return text
        .replaceAll(RegExp(r"[^\w\s]"), "")
        .toLowerCase()
        .split(RegExp(r"\s+"))
        .where((w) => w.isNotEmpty)
        .toList();
  }

  Color _accuracyColor(double percent) {
    if (percent >= 80) return Colors.green;
    if (percent >= 50) return Colors.orange;
    return Colors.red;
  }
}

class _Analysis {
  final double accuracy;
  final int correct;
  final int missed;
  final List<String> missedWords;

  _Analysis({
    required this.accuracy,
    required this.correct,
    required this.missed,
    required this.missedWords,
  });
}
