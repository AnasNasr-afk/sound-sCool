import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  Future<void> signupUser() async {
    if (!signupFormKey.currentState!.validate()) {
      debugPrint("Signup form validation failed");
      return;
    }
    emit(SignupLoadingState());

    try {
      debugPrint(
        "🔹 Creating user with email: ${signupEmailController.text.trim()}",
      );
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: signupEmailController.text.trim(),
            password: signupPasswordController.text.trim(),
          );

      final user = userCredential.user!;
      debugPrint("🎉 User created with UID: ${user.uid}");

      final fullName =
          "${signupFirstNameController.text.trim()} ${signupLastNameController.text.trim()}";
      debugPrint("🔹 Updating display name to: $fullName");
      await user.updateDisplayName(fullName);
      await user.reload();
      debugPrint("🔹 User display name updated");

      UserModel newUser = UserModel(
        uid: user.uid,
        firstName: signupFirstNameController.text.trim(),
        lastName: signupLastNameController.text.trim(),
        email: signupEmailController.text.trim(),
      );

      debugPrint("🔹 Saving user to Firestore: ${newUser.toMap()}");
      await _firestore.collection("users").doc(user.uid).set(newUser.toMap());

      emit(SignupSuccessState());
      debugPrint("Emitted SignupSuccessState");
    } on FirebaseAuthException catch (e) {
      debugPrint("FirebaseAuthException: ${e.message}");
      emit(SignupErrorState(e.message ?? "An unknown error occurred"));
    } catch (e) {
      debugPrint("Unexpected error: $e");
      emit(SignupErrorState(e.toString()));
    }
  }

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
        // 🔐 Store UID in local storage
        await SharedPrefHelper.setData(
          "uid",
          uid,
        );
        emit(LoginSuccessState());
      }
    } on FirebaseAuthException catch (e) {
      emit(LoginErrorState(e.message ?? "Login failed"));
    } catch (e) {
      emit(LoginErrorState("Something went wrong"));
    }
  }
}
