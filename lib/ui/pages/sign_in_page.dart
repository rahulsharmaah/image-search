import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_search/services/auth_services.dart';
import 'package:image_search/ui/pages/image_upload.dart';
import 'package:image_search/ui/pages/welcome_screen.dart';
class SignInPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign-In Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final User? user = await _authService.signInWithGoogle();
                if (user != null) {
                  // Navigate to welcome screen if sign-in is successful
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelcomeScreen(user: user),
                    ),
                  );
                } else {
                  // Show error message if sign-in fails
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sign-in failed. Please try again.'),
                    ),
                  );
                }
              },
              child: Text('Sign in with Google'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to ImageUploadScreen when button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageUploadScreen(),
                  ),
                );
              },
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
