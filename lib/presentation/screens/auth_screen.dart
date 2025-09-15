import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/helpers/color_manager.dart';
import 'package:sounds_cool/presentation/widgets/authWidgets/login_button.dart';
import 'package:sounds_cool/presentation/widgets/authWidgets/signup_button.dart';
import '../widgets/authWidgets/auth_bloc_listener.dart';
import '../widgets/authWidgets/auth_intro_widget.dart';
import '../widgets/authWidgets/continue_with_google_button.dart';
import '../widgets/authWidgets/login_form_fields.dart';
import '../widgets/authWidgets/signup_form_fields.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 30.h),

                /// Animation / Logo
                AuthIntroWidget(),
                SizedBox(height: 20.h),

                /// Custom Tab Bar
                Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.r),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: EdgeInsets.all(4.w),
                    labelColor: ColorManager.mainGreen,
                    unselectedLabelColor: Colors.grey[600],
                    labelStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: "Login"),
                      Tab(text: "Sign Up"),
                    ],
                  ),
                ),

                SizedBox(height: 40.h),

                /// Tab Content
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return SlideTransition(
                      position: animation.drive(
                        Tween(
                          begin: const Offset(0.3, 0),
                          end: Offset.zero,
                        ).chain(CurveTween(curve: Curves.easeInOut)),
                      ),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: Column(
                    key: ValueKey(_currentIndex),
                    children: [

                      _currentIndex == 0 ?
                      const LoginFormFields()
                          : const SignupFormFields(),

                      SizedBox(height: 20.h),


                      _currentIndex == 0 ?
                      const LoginButton()
                          : const SignupButton(),


                      /// Divider
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                                    height: 1, color: Colors.grey[300])),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                'or',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Container(
                                    height: 1, color: Colors.grey[300])),
                          ],
                        ),
                      ),

                      /// Google Sign In
                      ContinueWithGoogleButton(),
                      SizedBox(height: 24.h),

                      /// Bottom Toggle Text
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                          children: [
                            TextSpan(
                              text: _currentIndex == 0
                                  ? "Don't have an account? "
                                  : "Already have an account? ",
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  _tabController.animateTo(
                                    _currentIndex == 0 ? 1 : 0,
                                  );
                                },
                                child: Text(
                                  _currentIndex == 0 ? "Sign Up" : "Login",
                                  style: TextStyle(
                                    color: ColorManager.mainGreen,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

               AuthBlocListener(),
              ],
            ),
          ),
        ),
    );
  }
}
