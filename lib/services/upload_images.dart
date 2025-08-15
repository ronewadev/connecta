import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

class ImageUploadService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Upload a single profile image
  static Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('❌ No authenticated user found');
        return null;
      }

      print('📤 Starting profile image upload for user: ${currentUser.uid}');

      // Compress and process the image
      final compressedImage = await _compressImage(imageFile, quality: 85, maxWidth: 800);
      
      // Generate unique filename
      final String fileName = 'profile_${currentUser.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      // Create storage reference
      final Reference storageRef = _storage
          .ref()
          .child('users')
          .child(currentUser.uid)
          .child('profile')
          .child(fileName);

      print('📁 Upload path: users/${currentUser.uid}/profile/$fileName');

      // Set metadata
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'userId': currentUser.uid,
          'uploadType': 'profile',
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      // Upload file with progress tracking
      final UploadTask uploadTask = storageRef.putData(compressedImage!, metadata);
      
      // Track upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
         });

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;
      
      if (snapshot.state == TaskState.success) {
        // Get download URL
        final String downloadUrl = await storageRef.getDownloadURL();
        return downloadUrl;
      } else {
        return null;
      }

    } on FirebaseException catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Upload multiple gallery images
  static Future<List<String>> uploadGalleryImages(
    List<File> imageFiles, {
    Function(double)? onProgress,
  }) async {
    try {
      if (_auth.currentUser == null) {
        throw Exception('User must be authenticated to upload images');
      }

      final String userId = _auth.currentUser!.uid;

      List<String> downloadUrls = [];
      
      for (int i = 0; i < imageFiles.length; i++) {
        final File imageFile = imageFiles[i];

        // Compress the image
        final Uint8List? compressedImage = await _compressImage(imageFile);
        if (compressedImage == null) {
          continue;
        }

        // Create unique filename
        final String fileName = 'gallery_${i}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final Reference storageRef = _storage
            .ref()
            .child('users')
            .child(userId)
            .child('gallery')
            .child(fileName);

        try {
          // Upload compressed image
          final UploadTask uploadTask = storageRef.putData(
            compressedImage,
            SettableMetadata(contentType: 'image/jpeg'),
          );

          // Listen to upload progress
          uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
            double progress = (i + (snapshot.bytesTransferred / snapshot.totalBytes)) / imageFiles.length;
            onProgress?.call(progress);
          });

          final TaskSnapshot snapshot = await uploadTask;
          final String downloadUrl = await snapshot.ref.getDownloadURL();
          downloadUrls.add(downloadUrl);
          

        } catch (e) {
          print('❌Failed to upload gallery image ${i + 1}: $e');
          // Continue with other images even if one fails
        }
      }

      print('✅ Gallery upload completed. Uploaded ${downloadUrls.length}/${imageFiles.length} images');
      return downloadUrls;
      
    } on FirebaseException catch (e) {
      return [];
    } catch (e) {
      print('💥 Unexpected error uploading gallery images: $e');
      return [];
    }
  }

  /// Compress image to reduce file size while maintaining quality
  static Future<Uint8List?> _compressImage(
    File imageFile, {
    int quality = 85,
    int? maxWidth,
    int? maxHeight,
  }) async {
    try {
      // Read image file
      final Uint8List imageBytes = await imageFile.readAsBytes();
      
      // Decode image
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize if needed
      if (maxWidth != null || maxHeight != null) {
        image = img.copyResize(
          image,
          width: maxWidth,
          height: maxHeight,
          interpolation: img.Interpolation.linear,
        );
      }

      // Compress to JPEG
      final Uint8List compressedBytes = Uint8List.fromList(
        img.encodeJpg(image, quality: quality),
      );

      final originalSize = imageBytes.length / 1024; // KB
      final compressedSize = compressedBytes.length / 1024; // KB
      final compressionRatio = ((originalSize - compressedSize) / originalSize * 100);
      
      print('💾 Compression: ${originalSize.toStringAsFixed(1)}KB → ${compressedSize.toStringAsFixed(1)}KB (${compressionRatio.toStringAsFixed(1)}% reduction)');

      return compressedBytes;
      
    } catch (e) {
      print('💥 Error compressing image: $e');
      // Return original image bytes as fallback
      return await imageFile.readAsBytes();
    }
  }

  /// Delete an image from Firebase Storage
  static Future<bool> deleteImage(String downloadUrl) async {
    try {
      
      // Get storage reference from download URL
      final Reference storageRef = _storage.refFromURL(downloadUrl);
      
      // Delete the file
      await storageRef.delete();

      return true;
      
    } on FirebaseException catch (e) {
      print('💥 Firebase error deleting image: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('💥 Unexpected error deleting image: $e');
      return false;
    }
  }

  /// Get download URL from storage path
  static Future<String?> getDownloadUrl(String storagePath) async {
    try {
      final Reference storageRef = _storage.ref(storagePath);
      final String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('💥 Error getting download URL: $e');
      return null;
    }
  }

  /// List all images for a user
  static Future<List<String>> getUserImages(String userId) async {
    try {
      print('📋 Fetching images for user: $userId');
      
      final List<String> imageUrls = [];
      
      // Get profile images
      try {
        final ListResult profileResult = await _storage
            .ref()
            .child('users')
            .child(userId)
            .child('profile')
            .listAll();
            
        for (final Reference ref in profileResult.items) {
          final String downloadUrl = await ref.getDownloadURL();
          imageUrls.add(downloadUrl);
        }
      } catch (e) {
        print('⚠️ No profile images found for user $userId');
      }
      
      // Get gallery images
      try {
        final ListResult galleryResult = await _storage
            .ref()
            .child('users')
            .child(userId)
            .child('gallery')
            .listAll();
            
        for (final Reference ref in galleryResult.items) {
          final String downloadUrl = await ref.getDownloadURL();
          imageUrls.add(downloadUrl);
        }
      } catch (e) {
        print('⚠️ No gallery images found for user $userId');
      }

      print('📊 Found ${imageUrls.length} total images for user $userId');
      return imageUrls;
      
    } catch (e) {
      print('💥 Error fetching user images: $e');
      return [];
    }
  }
}

// Legacy function for backward compatibility

Future<List<String>> uploadImages(
  List<File> images, {
  Function(double)? onProgress,
}) async {
  return ImageUploadService.uploadGalleryImages(images, onProgress: onProgress);
}