import 'package:flutter/material.dart';
import 'package:about/about.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sounds_cool/helpers/color_manager.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  String _version = '';
  String _buildNumber = '';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
      _buildNumber = info.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    return Scaffold(
      body: AboutPage(
        values: {
          'version': _version,
          'buildNumber': _buildNumber,
          'year': currentYear.toString(),
          'author': 'Anas Nasr',
        },
        title: const Text('About App'),
        applicationName: 'Sounds Cool App',
        applicationVersion: 'Version {{ version }} (+{{ buildNumber }})',
        applicationIcon: Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorManager.gradientLightDark,
                ColorManager.mainGreen,

              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32.r),
              bottomRight: Radius.circular(32.r),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF20C997).withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.3),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    color: Colors.white,
                    child: Image.asset(
                      'assets/images/appIcon.png',
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        applicationDescription: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: const Text(
            'Sounds Cool is an interactive app that helps users improve their reading and speaking skills in different languages. It generates short AI-based texts based on the user\'s level and language, then listens as they read aloud. The app instantly highlights correct and incorrect pronunciations, making language practice engaging and effective.',
            textAlign: TextAlign.justify,
          ),
        ),
        applicationLegalese: '© {{ author }}, {{ year }}. All rights reserved.',
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          ),
          MarkdownPageListTile(
            filename: 'LICENSE.md',
            title: const Text('View License'),
            icon: const Icon(Icons.description_outlined),
          ),
          LicensesPageListTile(
            title: const Text('Open Source Licenses'),
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),
    );
  }
}