import 'package:expense_tracker/controllers/auth_controller.dart';
import 'package:expense_tracker/screens/home.dart';
import 'package:expense_tracker/routes/routes.dart';
import 'package:expense_tracker/routes/routes_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  // runApp(
  //   GetMaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     theme: ThemeData.dark(),
  //     // home: const MainScreen(),
  //     initialRoute: RoutesClass.getLoginRoute (),
  //     getPages: RoutesClass().routes,
  //   ),
  // );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final _dbC = Get.put(DatabaseController(), permanent: true);
    final _authC = Get.put(
      AuthController(),
      permanent: true,
    );
    // final _dbC = Get.put(
    //   DatabaseController(),
    //   permanent: true,
    // );
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // print(snapshot.data);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        if (snapshot.hasData) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              textTheme: GoogleFonts.merriweatherTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            // home: Home(),
            initialRoute: RouteName.home,
            getPages: RoutesClass.pages,
          );
        } else {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              textTheme: GoogleFonts.merriweatherTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            // home: const MainScreen(),
            initialRoute: RouteName.login,
            getPages: RoutesClass.pages,
          );
        }
        // if (snapshot.hasData) {
        //   return GetMaterialApp(
        //     debugShowCheckedModeBanner: false,
        //     theme: ThemeData.dark(),
        //     home: const MainScreen(),
        //     // initialRoute: RoutesClass.getLoginRoute(),
        //     getPages: RoutesClass().routes,
        //   );
        // }
        // if (snapshot.connectionState == ConnectionState.active) {
        //   if (snapshot.data == null) {
        //     return GetMaterialApp(
        //       debugShowCheckedModeBanner: false,
        //       theme: ThemeData(
        //         textTheme: GoogleFonts.merriweatherTextTheme(
        //           Theme.of(context).textTheme,
        //         ),
        //       ),
        //       // theme: ThemeData.dark(),
        //       // home: const MainScreen(),
        //       initialRoute: RouteName.login,
        //       getPages: RoutesClass.pages,
        //     );
        //   }
        //   return GetMaterialApp(
        //     debugShowCheckedModeBanner: false,
        //     theme: ThemeData(
        //       textTheme: GoogleFonts.merriweatherTextTheme(
        //         Theme.of(context).textTheme,
        //       ),
        //     ),
        //     home: Home(),
        //     // initialRoute: RoutesClass.getLoginRoute(),
        //     getPages: RoutesClass.pages,
        //   );
        // }
        // return GetMaterialApp(
        //   debugShowCheckedModeBanner: false,
        //   theme: ThemeData(
        //     textTheme: GoogleFonts.merriweatherTextTheme(
        //       Theme.of(context).textTheme,
        //     ),
        //   ),
        //   // home: const MainScreen(),
        //   initialRoute: RouteName.login,
        //   getPages: RoutesClass.pages,
        // );
      },
    );
  }
}
