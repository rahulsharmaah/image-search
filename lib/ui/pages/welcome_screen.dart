import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'dart:io'; // Import File class
import 'package:image_search/ui/pages/image_upload.dart';

class WelcomeScreen extends StatefulWidget {
  final User user;

  WelcomeScreen({required this.user});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<String> imageURLs = []; // List to store image URLs
  bool isGridView =
      true; // Flag to track whether to display grid view or list view
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadImages(); // Load images when the screen is built or dependencies change
  }

  @override
  void initState() {
    super.initState();
    loadImages(); // Load user's images when the screen initializes
  }

  // Function to load user's images from Firebase Cloud Storage
  void loadImages() async {
    try {
      // Create a reference to the user's image folder
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('user_images/${widget.user.uid}/');

      // Get the list of items (images) in the folder
      ListResult result = await storageReference.listAll();

      // Extract the download URLs of the images and store them in imageURLs list
      imageURLs =
          await Future.wait(result.items.map((item) => item.getDownloadURL()));

      // Update the UI
      setState(() {});
    } catch (e) {
      print('Error loading images: $e');
      // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_on),
            onPressed: () {
              // Toggle between grid view and list view
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${widget.user.displayName}!',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            // Display grid view or list view based on the selected mode
            isGridView ? buildGridView() : buildListView(),
            ElevatedButton(
              onPressed: () {
                // Navigate to ImageUploadScreen when button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageUploadScreen()),
                );
              },
              child: const Text('Upload Image'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Implement sign-out functionality
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/sign_in');
                  // Navigate to the login screen or any other screen after sign out
                } catch (e) {
                  print('Error signing out: $e');
                  // Handle sign-out errors
                }
              },
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build grid view of images
  Widget buildGridView() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: imageURLs.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              // Navigate to ImageDetailsScreen to view full image
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ImageDetailsScreen(imageURL: imageURLs[index]),
                ),
              );
            },
            child: Image.network(
              imageURLs[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  // Function to build list view of images
  Widget buildListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: imageURLs.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              // Navigate to ImageDetailsScreen to view full image
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ImageDetailsScreen(imageURL: imageURLs[index]),
                ),
              );
            },
            title: Image.network(
              imageURLs[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}

class ImageDetailsScreen extends StatelessWidget {
  final String imageURL;

  ImageDetailsScreen({required this.imageURL});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Details'),
      ),
      body: Center(
        child: Image.network(
          imageURL,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
