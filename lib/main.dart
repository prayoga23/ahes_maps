import 'package:ahes_maps/screens/admin/home_admin_screen.dart';
import 'package:ahes_maps/screens/login_screen.dart';
import 'package:ahes_maps/screens/web_ar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'ui/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  // await initializeSharedPreferences();

  final prefs = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(prefs);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ahes Maps',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Splash(),
      getPages: [
        GetPage(
          name: '/homeAdmin',
          page: () => HomeAdminScreen(),
        ),
        GetPage(
          name: '/login',
          page: () => LoginScreen(),
        ),
        GetPage(
          name: '/webAR',
          page: () => WebARScreen(),
        ),
      ],
    );
  }
}
