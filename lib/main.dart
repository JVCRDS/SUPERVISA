import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'firebase_options.dart';
import 'pages/login/login_page.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';


var logger = Logger();
void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  logger.d(
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ),
  );
  runApp(DevicePreview(builder: (context) => const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: LoginPage());
  }
}
