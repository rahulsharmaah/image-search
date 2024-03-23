import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_search/ui/pages/image_upload.dart';

class WelcomeScreen extends StatelessWidget {
  final User user;

  WelcomeScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${user.displayName}!',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to ImageUploadScreen when button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageUploadScreen()),
                );
              },
              child: Text('Upload Image'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement sign-out functionality
              },
              child: Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
