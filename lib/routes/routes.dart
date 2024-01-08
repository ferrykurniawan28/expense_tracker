import 'package:expense_tracker/bindings/forgetBinding.dart';
import 'package:expense_tracker/bindings/homeBinding.dart';
import 'package:expense_tracker/bindings/loginBinding.dart';
import 'package:expense_tracker/bindings/signupBinding.dart';
import 'package:expense_tracker/screens/forget_password.dart';
import 'package:expense_tracker/screens/home.dart';
import 'package:expense_tracker/screens/login.dart';
import 'package:expense_tracker/routes/routes_name.dart';
import 'package:expense_tracker/screens/signup.dart';
import 'package:get/get.dart';

class RoutesClass {
  static final pages = [
    GetPage(
      name: RouteName.login,
      page: () => const Login(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: RouteName.home,
      page: () => Home(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: RouteName.signUp,
      page: () => SignUp(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: RouteName.forgetPassword,
      page: () => const ForgetPassword(),
      binding: ForgetBinding(),
    ),
  ];
}
