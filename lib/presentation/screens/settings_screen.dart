import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sounds_cool/business_logic/settingsCubit/settings_cubit.dart';
import 'package:sounds_cool/helpers/notification_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../helpers/color_manager.dart';
import '../../helpers/components.dart';
import '../../helpers/text_styles.dart';
import '../../routing/routes.dart';
import '../widgets/settingsWidgets/settings_bloc_listener.dart';
import '../widgets/settingsWidgets/settings_group.dart';
import '../widgets/settingsWidgets/settings_item.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  /// Initialize notification status from helper
  Future<void> _initializeNotifications() async {
    final isEnabled = await NotificationHelper.isNotificationsEnabled();
    setState(() {
      _notificationsEnabled = isEnabled;
    });
  }

  /// Handle notification switch toggle
  Future<void> _handleNotificationToggle(bool value) async {
    if (value) {
      // User wants to enable notifications
      _showNotificationDialog();
    } else {
      // User wants to disable notifications
      await NotificationHelper.disableNotificationsFlow();
      setState(() {
        _notificationsEnabled = false;
      });
    }
  }

  /// Show platform-specific confirmation dialog for enabling notifications
  void _showNotificationDialog() {
    if (Platform.isIOS) {
      _showIOSDialog();
    } else {
      _showAndroidDialog();
    }
  }

  /// iOS native dialog using CupertinoAlertDialog
  void _showIOSDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Enable Notifications?'),
        content: const Text(
          'Allow notifications to receive important updates and reminders.',
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _notificationsEnabled = false;
              });
            },
            child: const Text('Deny'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              Navigator.pop(context);
              final isGranted = await NotificationHelper.enableNotificationsFlow();

              setState(() {
                _notificationsEnabled = isGranted;
              });

              if (!isGranted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notification permission denied'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('Allow'),
          ),
        ],
      ),
    );
  }

  /// Android native dialog using AlertDialog
  void _showAndroidDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text('Enable Notifications?',

            style: TextStyles.font20BlackBold.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            )
        ),
        content:  Text(
          'Allow notifications to receive important updates and reminders.',
          style: TextStyles.font16LightBlackSemiBold.copyWith(
            fontSize: 14.sp,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _notificationsEnabled = false;
              });
            },
            child: Text(

                'Deny',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final isGranted = await NotificationHelper.enableNotificationsFlow();

              setState(() {
                _notificationsEnabled = isGranted;
              });

              if (!isGranted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notification permission denied'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Text('Allow',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorManager.mainGreen,
                fontWeight: FontWeight.w600,

            ),
          ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 18.w,
            color: ColorManager.mainBlack,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyles.font20BlackBold.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsSection(
              title: "Account",
              children: [
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(18.r),
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ColorManager.mainGrey.withValues(alpha: 0.3),
                        width: 1.2.w,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.r),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.darkGrey.withValues(alpha: 0.1),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
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
                                user?.displayName ?? "Guest",
                                style: TextStyles.font20BlackBold.copyWith(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                user?.email ?? "No email",
                                style: TextStyles.font16LightBlackSemiBold
                                    .copyWith(
                                  fontSize: 14.sp,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w400,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: ColorManager.mainGreen.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            "FREE",
                            style: TextStyles.font16LightBlackSemiBold
                                .copyWith(
                              fontSize: 12.sp,
                              color: ColorManager.mainGreen,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            SettingsSection(
              title: "Preferences",
              children: [
                SettingsItem(
                  icon: Icons.notifications_outlined,
                  title: "Notifications",
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: _handleNotificationToggle,
                    inactiveTrackColor: Colors.grey.shade300,
                    inactiveThumbColor: Colors.grey.shade500,
                    activeThumbColor: ColorManager.mainGreen,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
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
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      Routes.helpFaqScreen,
                    );
                  },
                ),
                SettingsItem(
                  icon: Icons.share_outlined,
                  title: "Share App",
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                    size: 20.sp,
                  ),
                  onTap: () async {
                    const androidLink =
                        'https://play.google.com/store/apps/details?id=com.example.sounds_cool';
                    const iosLink =
                        'https://apps.apple.com/app/id1234567890';

                    final appLink = Platform.isAndroid ? androidLink : iosLink;

                    final message = '''Check out *Sounds Cool*! 🎧  
An interactive app that helps you improve your reading and pronunciation skills.

Download it here:
$appLink
''';

                    final box = context.findRenderObject() as RenderBox?;

                    await SharePlus.instance.share(
                      ShareParams(
                        text: message,
                        title: 'Try the Sounds Cool App!',
                        subject: 'Sounds Cool - Improve your language skills',
                        sharePositionOrigin:
                        box!.localToGlobal(Offset.zero) & box.size,
                      ),
                    );
                  },
                ),
                SettingsItem(
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy Policy",
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                    size: 20.sp,
                  ),
                  onTap: () async {
                    final Uri url = Uri.parse(
                      'https://anasnasr-afk.github.io/sound-sCool/PRIVACY_POLICY',
                    );
                    if (!await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    )) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Could not open Privacy Policy'),
                        ),
                      );
                    }
                  },
                ),
                SettingsItem(
                  icon: Icons.info_outline,
                  title: "About App",
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                    size: 20.sp,
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      Routes.aboutAppScreen,
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 24.h),
            SettingsSection(
              title: "Actions",
              children: [
                SettingsItem(
                  icon: Icons.logout,
                  title: "Sign Out",
                  destructive: true,
                  onTap: () {
                    showSignOutDialog(
                      context,
                      onConfirm: () {
                        Navigator.of(context).pop();
                        context.read<SettingsCubit>().signOut();
                      },
                    );
                  },
                ),
                SettingsItem(
                  icon: Icons.delete_outline,
                  title: "Delete Account",
                  destructive: true,
                  onTap: () {
                    showPasswordDialog(
                      context,
                      onConfirm: (password) {
                        context.read<SettingsCubit>().deleteAccount(password);
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 40.h),
            SettingsBlocListener(),
          ],
        ),
      ),
    );
  }
}