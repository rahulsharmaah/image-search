import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final picker = ImagePicker();
  List<String> _uploadedImageUrls = [];

  bool _isLoading = false;
  String _errorMessage = '';
  String _successMessage = '';

  Future<void> _uploadMultipleImages() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final List<XFile>? pickedFiles = await picker.pickMultiImage();

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        for (XFile pickedFile in pickedFiles) {
          File imageFile = File(pickedFile.path);
          await _uploadAndCompressImage(imageFile);
        }
        setState(() {
          _successMessage = 'Images uploaded successfully.';
          Navigator.popAndPushNamed(context, '/welcome'); //
        });
      } else {
        setState(() {
          _errorMessage = 'No images selected.';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error picking images: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _uploadSimilarImages(File imageFile) async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Implement logic to search for similar images and display them

      // For now, we're just uploading and compressing the image again
      await _uploadAndCompressImage(imageFile);

      setState(() {
        _successMessage = 'Similar images found and uploaded successfully.';
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Error uploading similar images: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _uploadAndCompressImage(File imageFile) async {
    try {
      File compressedImage = await compressImage(imageFile);
      String imageUrl = await uploadToFirebase(compressedImage);
      setState(() {
        _uploadedImageUrls.add(imageUrl);
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Error uploading image: $error';
      });
    }
  }

  Future<File> compressImage(File imageFile) async {
    // Implement your image compression logic here
    // For simplicity, we're returning the same image file here.
    return imageFile;
  }

  Future<String> uploadToFirebase(File file) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Retrieve the UID of the current user
      String uid = user.uid;

      // Create a storage reference with user-specific path
      Reference storageReference = storage
          .ref()
          .child('user_images/$uid/${DateTime.now().millisecondsSinceEpoch}');

      // Upload file to Firebase Storage
      UploadTask uploadTask = storageReference.putFile(file);

      // Wait for upload to complete
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

      // Get the download URL of the uploaded file
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Return the download URL
      return downloadUrl;
    } else {
      // Handle the case where no user is signed in
      throw Exception('No user signed in.');
    }
  }

  void _onSearchSimilarImagesPressed() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        await _uploadSimilarImages(imageFile);
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error picking image: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Upload'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: _isLoading ? null : _uploadMultipleImages,
            child: const Text('Upload Multiple Images'),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _onSearchSimilarImagesPressed,
            child: const Text('Search Similar Images'),
          ),
          if (_isLoading)
            const CircularProgressIndicator()
          else if (_errorMessage.isNotEmpty)
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
            )
          else if (_successMessage.isNotEmpty)
            Text(
              _successMessage,
              style: const TextStyle(color: Colors.green),
            ),
          Expanded(
            child: _uploadedImageUrls.isEmpty
                ? const Center(child: Text('No images uploaded yet'))
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: _uploadedImageUrls.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.network(
                        _uploadedImageUrls[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _uploadMultipleImages,
        tooltip: 'Capture Image',
        child: const Icon(Icons.camera),
      ),
    );
  }
}
