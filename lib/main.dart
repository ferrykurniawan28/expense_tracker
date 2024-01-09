import 'package:expense_tracker/bindings/initialBinding.dart';
import 'package:expense_tracker/routes/routes.dart';
import 'package:expense_tracker/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final _authC = Get.put(
    //   AuthController(),
    //   permanent: true,
    // );
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.merriweatherTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      // home: const MainScreen(),
      initialBinding: InitialBinding(),
      initialRoute: RouteName.splash,
      getPages: RoutesClass.pages,
    );
    // return StreamBuilder(
    //   stream: FirebaseAuth.instance.authStateChanges(),
    //   builder: (context, snapshot) {
    //     // print(snapshot.data);
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    //     if (snapshot.hasError) {
    //       return const Center(
    //         child: Text('Something went wrong'),
    //       );
    //     }
    //     if (snapshot.hasData) {
    //       return GetMaterialApp(
    //         debugShowCheckedModeBanner: false,
    //         theme: ThemeData(
    //           textTheme: GoogleFonts.merriweatherTextTheme(
    //             Theme.of(context).textTheme,
    //           ),
    //         ),
    //         // home: Home(),
    //         initialRoute: RouteName.home,
    //         getPages: RoutesClass.pages,
    //       );
    //     } else {
    //       return GetMaterialApp(
    //         debugShowCheckedModeBanner: false,
    //         theme: ThemeData(
    //           textTheme: GoogleFonts.merriweatherTextTheme(
    //             Theme.of(context).textTheme,
    //           ),
    //         ),
    //         // home: const MainScreen(),
    //         initialRoute: RouteName.login,
    //         getPages: RoutesClass.pages,
    //       );
    //     }
    //   },
    // );
  }
}
