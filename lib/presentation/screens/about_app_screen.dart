import 'package:flutter/material.dart';
import 'package:about/about.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
      // appBar: AppBar(
      //   title: const Text('About App'),
      // ),
      body: AboutPage(
        values: {
          'version': _version,
          'buildNumber': _buildNumber,
          'year': currentYear.toString(),
          'author': 'Anas Nasr',
        },
        title: const Text('About App'),
        applicationName: 'Sounds Cool App',
        applicationVersion: 'Version {{ version }} ',
        applicationIcon: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Image.asset(
            'assets/images/appIcon.png',
            width: 80.w,
            height: 80.h,
            filterQuality: FilterQuality.high,

          ),
        ),
        applicationDescription: const Text(
          'Sounds Cool is an interactive app that helps users improve their reading and speaking skills in different languages.'
              'It generates short AI-based texts based on the user’s level and language, then listens as they read aloud.'
              'The app instantly highlights correct and incorrect pronunciations, making language practice engaging and effective.',
          textAlign: TextAlign.justify,
        ),
        applicationLegalese: '© {{ author }}, {{ year }}',
        children: const [
          MarkdownPageListTile(
            filename: 'LICENSE.md',
            title: Text('View License'),
            icon: Icon(Icons.description_outlined),
          ),
          LicensesPageListTile(
            title: Text('Open Source Licenses'),
            icon: Icon(Icons.favorite_border),
          ),
        ],
      ),
    );
  }
}
