import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/models/user_model.dart';
import '../../helpers/shared_pref_helper.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(BuildContext context) => BlocProvider.of(context);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  final signupFirstNameController = TextEditingController();
  final signupLastNameController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();

  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  // ===============================
  // SIGN UP (Email & Password)
  // ===============================
  Future<void> signupUser() async {
    if (!signupFormKey.currentState!.validate()) return;

    emit(SignupLoadingState());

    try {
      // Create user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: signupEmailController.text.trim(),
        password: signupPasswordController.text.trim(),
      );

      final user = userCredential.user!;
      final fullName =
          "${signupFirstNameController.text.trim()} ${signupLastNameController.text.trim()}";

      await user.updateDisplayName(fullName);
      await user.reload();

      // Save to Firestore
      UserModel newUser = UserModel(
        uid: user.uid,
        firstName: signupFirstNameController.text.trim(),
        lastName: signupLastNameController.text.trim(),
        email: signupEmailController.text.trim(),
        photoUrl: user.photoURL ?? "",
        phone: user.phoneNumber ?? "",
      );

      await _firestore.collection("users").doc(user.uid).set(newUser.toMap());
      await SharedPrefHelper.setData("uid", user.uid);

      emit(SignupSuccessState());
    } on FirebaseAuthException catch (e) {
      emit(SignupErrorState(e.message ?? "Signup failed"));
    } catch (e) {
      emit(SignupErrorState("Something went wrong"));
    }
  }

  // ===============================
  // LOGIN (Email & Password)
  // ===============================
  Future<void> loginUser(BuildContext context) async {
    if (!loginFormKey.currentState!.validate()) return;

    emit(LoginLoadingState());

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: loginEmailController.text.trim(),
        password: loginPasswordController.text.trim(),
      );

      final uid = credential.user?.uid;
      if (uid != null) {
        await SharedPrefHelper.setData("uid", uid);
        emit(LoginSuccessState());
      }
    } on FirebaseAuthException catch (e) {
      emit(LoginErrorState(e.message ?? "Login failed"));
    } catch (e) {
      emit(LoginErrorState("Something went wrong"));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(GoogleSignInLoadingState());

    try {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();

      final googleUser = await googleSignIn.authenticate();

      if (googleUser == null) {
        emit(GoogleSignInErrorState("Google sign-in cancelled"));
        return;
      }

      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        emit(GoogleSignInErrorState("Failed to retrieve Google ID Token"));
        return;
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);

      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user!;

      final firestore = FirebaseFirestore.instance;
      final userDoc = await firestore.collection("users").doc(user.uid).get();

      if (!userDoc.exists) {
        final nameParts = (user.displayName ?? "").split(" ");
        final newUser = UserModel(
          uid: user.uid,
          firstName: nameParts.isNotEmpty ? nameParts.first : "",
          lastName: nameParts.length > 1 ? nameParts.last : "",
          email: user.email ?? "",
          photoUrl: user.photoURL ?? "",
        );
        await firestore.collection("users").doc(user.uid).set(newUser.toMap());
      }

      await SharedPrefHelper.setData("uid", user.uid);
      emit(GoogleSignInSuccessState());
    } on FirebaseAuthException catch (e) {
      emit(GoogleSignInErrorState(e.message ?? "Firebase login failed"));
    } on GoogleSignInException catch (e) {
      emit(GoogleSignInErrorState("Google Sign-In Error: ${e.code}"));
    } catch (e) {
      emit(GoogleSignInErrorState("Something went wrong: $e"));
    }
  }



}
