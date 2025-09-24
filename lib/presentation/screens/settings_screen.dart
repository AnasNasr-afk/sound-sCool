import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helpers/color_manager.dart';
import '../../helpers/components.dart';
import '../../helpers/text_styles.dart';
import '../widgets/settingsWidgets/settings_group.dart';
import '../widgets/settingsWidgets/settings_item.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundColor2,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.darkGrey.withValues(alpha: 0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 18.w,
              color: ColorManager.mainBlack,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          'Settings',
          style: TextStyles.font20BlackBold.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Profile header card - clickable for edit profile
            InkWell(
              onTap: () {
                ///TODO: Navigate to Edit Profile Screen
              },
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.darkGrey.withValues(alpha: 0.3),
                      spreadRadius: 0,
                      blurRadius: 1,
                      offset: const Offset(1, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Anas Nasr",
                            style: TextStyles.font20BlackBold.copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "anasnasr1234@gmail.com",
                            style: TextStyles.font16LightBlackSemiBold.copyWith(
                              fontSize: 14.sp,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF10B981,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            "FREE",
                            style: TextStyles.font16LightBlackSemiBold.copyWith(
                              fontSize: 12.sp,
                              color: const Color(0xFF10B981),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.grey.shade400,
                          size: 24.sp,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24.h),

            ///Account Section
            SettingsSection(
              title: "Account",
              children: [
                SettingsItem(
                  icon: Icons.history,
                  title: "Voice Records History",
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                    size: 20.sp,
                  ),
                  onTap: () {},
                ),
                SettingsItem(
                  icon: Icons.notifications_outlined,
                  title: "Notifications",
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {},
                    activeThumbColor: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            /// Support & Info Section
            SettingsSection(
              title: "Support & Info",
              children: [
                SettingsItem(
                  icon: Icons.help_outline,
                  title: "Help & FAQ",
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                    size: 20.sp,
                  ),
                  onTap: () {},
                ),
                SettingsItem(
                  icon: Icons.share_outlined,
                  title: "Share App",
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                    size: 20.sp,
                  ),
                  onTap: () {},
                ),
                SettingsItem(
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy Policy",
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                    size: 20.sp,
                  ),
                  onTap: () {},
                ),
                SettingsItem(
                  icon: Icons.info_outline,
                  title: "About App",
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                    size: 20.sp,
                  ),
                  onTap: () {},
                ),
              ],
            ),

            SizedBox(height: 24.h),

            /// Actions Section
            SettingsSection(
              title: "Actions",
              children: [
                SettingsItem(
                  icon: Icons.logout,
                  title: "Sign Out",
                  destructive: true,
                  onTap: () {
                    showSignOutDialog(context);
                  },
                ),
                SettingsItem(
                  icon: Icons.delete_outline,
                  title: "Delete Account",
                  destructive: true,
                  onTap: () {
                    showDeleteAccountDialog(context);
                  },
                ),
              ],
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
