import 'dart:async';

import 'package:expense_tracker/controllers/database_controller.dart';
import 'package:expense_tracker/routes/routes_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final _auth = FirebaseAuth.instance;
  RxBool isLoggedIn = false.obs;

  Stream<User?> get streamUserState => _auth.authStateChanges();

  @override
  void onInit() {
    _subscribe();
    super.onInit();
  }

  String currentUserID() {
    final uid = _auth.currentUser!.uid;
    return uid;
  }

  void _subscribe() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        isLoggedIn(false);
        // log('User is currently signed out');
        // print('User is currently signed out');
      } else {
        isLoggedIn(true);
        // log('User is signed in');
        // print('User is signed in');
      }
    });
  }

  void login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar('Success', 'Logged in successfully');
      // Get.toNamed(RouteName.home);
      Get.offAllNamed(RouteName.home);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message!);
    }
  }

  void register(String email, String password, String username) async {
    final db = Get.put(DatabaseController());
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await db.createAccount(email, email, password);
      Get.snackbar('Success', 'Registered successfully');
      Get.offAllNamed(RouteName.home);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message!);
    }
  }

  void forgetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar('Success', 'Reset password email sent');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message!);
    }
  }

  void logout() async {
    await _auth.signOut();
    Timer.periodic(const Duration(seconds: 4), (timer) {});
    Get.snackbar('Success', 'Logged out successfully');
    Get.offAllNamed(RouteName.login);
  }
}
