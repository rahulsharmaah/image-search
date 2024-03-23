import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_search/ui/pages/image_upload.dart';
import 'package:image_search/ui/pages/sign_in_page.dart';
import 'package:image_search/ui/pages/welcome_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments; // Retrieve arguments if passed

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SignInPage());
      case '/sign_in':
        return MaterialPageRoute(builder: (_) => SignInPage());
      case '/welcome':
        if (args is User) {
          // Pass the User object to WelcomeScreen if available
          return MaterialPageRoute(builder: (_) => WelcomeScreen(user: args));
        } else {
          // If User object is not available, navigate back to sign-in page
          return MaterialPageRoute(builder: (_) => SignInPage());
        }
      case '/image_upload':
        return MaterialPageRoute(builder: (_) => ImageUploadScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
