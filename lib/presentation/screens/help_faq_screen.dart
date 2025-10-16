import 'package:flutter/material.dart';
import 'package:flutter_easy_faq/flutter_easy_faq.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelpFaqScreen extends StatelessWidget {
  const HelpFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & FAQ'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              EasyFaq(
                backgroundColor: Colors.white,
                questionTextStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
                anserTextStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
                question: 'How do I use Sounds Cool?',
                answer:
                    'Simply pick your target language and level, then start reading. The app listens and highlights pronunciation errors instantly.',
              ),
              SizedBox(height: 10.h),

              EasyFaq(
                backgroundColor: Colors.white,
                questionTextStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
                anserTextStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
                question: 'Why is my microphone not working?',
                answer:
                    'Make sure microphone permission is enabled in your phone settings under Sounds Cool > Permissions.',
              ),
              SizedBox(height: 10.h),

              EasyFaq(
                backgroundColor: Colors.white,
                questionTextStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
                anserTextStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
                question: 'Is my data saved securely?',
                answer:
                    'Yes, your progress and recordings are stored safely in Firebase with authentication.',
              ),
              SizedBox(height: 10.h),


              EasyFaq(
                backgroundColor: Colors.white,
                questionTextStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
                anserTextStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
                question: 'How can I reset my password?',
                answer:
                'If you forgot your password, please contact our support team at anas.nasr132003@gmail.com for assistance. We’ll help you securely reset it as soon as possible.',
              ),
              SizedBox(height: 10.h),


              EasyFaq(
                backgroundColor: Colors.white,
                questionTextStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
                anserTextStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
                question: 'Who developed Sounds Cool?',
                answer:
                    'The app was created by Anas Nasr using Flutter, Firebase, and Google Gemini APIs.',
              ),
              SizedBox(height: 10.h),


              EasyFaq(
                backgroundColor: Colors.white,
                questionTextStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
                anserTextStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
                question: 'What happens if I log out?',
                answer:
                    'Your saved data remains securely stored in Firebase. You can restore all your progress anytime by logging back into your account.',
              ),
              SizedBox(height: 10.h),

              EasyFaq(
                backgroundColor: Colors.white,
                questionTextStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
                anserTextStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
                question: 'How accurate is the pronunciation evaluation?',
                answer:
                    'Sounds Cool uses Google’s advanced speech recognition models, achieving around 90–95% accuracy under clear conditions. However, background noise or unclear speech may affect results slightly.',
              ),
              SizedBox(height: 10.h),

              EasyFaq(
                backgroundColor: Colors.white,
                questionTextStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
                anserTextStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
                question: 'I found a bug. How can I report it?',
                answer:
                    'Please use the “Report a Problem” option in the Settings screen or email our support team directly at anas.nasr132003@gmail.com. Thank you for helping us improve the app!',
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
