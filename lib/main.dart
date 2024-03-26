import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_search/firebase_options.dart';
import 'package:image_search/services/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Google Sign-In Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Specify the initial route and route generator
      initialRoute: '/',
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
