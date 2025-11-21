import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../helpers/color_manager.dart';
import '../../../../../../helpers/text_styles.dart';

class SecondaryActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  // Fully customizable values
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? iconColor;

  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;

  const SecondaryActionButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.backgroundColor,   // null = transparent
    this.textColor,         // null = auto
    this.borderColor,       // null = none
    this.iconColor,
    this.height,
    this.borderRadius,
    this.fontSize,
    this.iconSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final double finalHeight = height ?? 44.h;
    final double finalRadius = borderRadius ?? 16.r;

    // Default colors
    final Color bg = backgroundColor ?? Colors.transparent;
    final Color finalBorderColor = borderColor ?? Colors.transparent;
    final Color finalTextColor = textColor ?? ColorManager.mainBlack;
    final Color finalIconColor = iconColor ?? finalTextColor;

    return Container(
      height: finalHeight,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(finalRadius),
        border: Border.all(color: finalBorderColor, width: borderColor != null ? 1.5 : 0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(finalRadius),
          child: Padding(
            padding: padding ??
                EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: iconSize ?? 18.sp,
                    color: finalIconColor,
                  ),
                  SizedBox(width: 6.w),
                ],
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyles.font14GreyRegular.copyWith(
                    color: finalTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: fontSize ?? 13.sp,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
