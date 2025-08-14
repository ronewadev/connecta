import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connecta/services/update_database.dart';

class ImagesSectionWidget extends StatefulWidget {
  final List<String> profileImages;
  final VoidCallback onImagesUpdated;

  const ImagesSectionWidget({
    Key? key,
    required this.profileImages,
    required this.onImagesUpdated,
  }) : super(key: key);

  @override
  State<ImagesSectionWidget> createState() => _ImagesSectionWidgetState();
}

class _ImagesSectionWidgetState extends State<ImagesSectionWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: _isExpanded 
                    ? const BorderRadius.vertical(top: Radius.circular(16))
                    : BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.images,
                      color: Colors.purple,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Images',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '${widget.profileImages.length} photos',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: FaIcon(
                      FontAwesomeIcons.chevronDown,
                      size: 18,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isExpanded ? null : 0,
            child: _isExpanded ? _buildImagesContent(context) : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesContent(BuildContext context) {
    final theme = Theme.of(context);
    final images = widget.profileImages;
    
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 16),
          Text(
            'Upload up to 5 photos to showcase yourself',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: 5, // Max 5 images
            itemBuilder: (context, index) {
              return _buildImageContainer(context, index, images);
            },
          ),
          if (images.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Photo Tips:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '• Show your face clearly in the first photo\n'
              '• Include variety: close-ups and full body\n'
              '• Use natural lighting when possible\n'
              '• Show your interests and hobbies\n'
              '• Smile and be authentic!',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context, int index, List<String> images) {
    final theme = Theme.of(context);
    final hasImage = index < images.length;
    final isMainPhoto = index == 0;
    
    return GestureDetector(
      onTap: () => hasImage ? _showImageOptions(context, index) : _pickImage(index),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasImage
                ? theme.colorScheme.primary.withOpacity(0.3)
                : theme.colorScheme.outline.withOpacity(0.3),
            width: hasImage ? 2 : 1,
          ),
          boxShadow: hasImage ? [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: hasImage
            ? Stack(
                children: [
                  // Image
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: theme.colorScheme.surface,
                            child: Center(
                              child: FaIcon(
                                FontAwesomeIcons.exclamationTriangle,
                                color: theme.colorScheme.error,
                                size: 24,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  // Main Photo Badge
                  if (isMainPhoto)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Main',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  
                  // Options Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.ellipsis,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.plus,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isMainPhoto ? 'Main Photo' : 'Add Photo',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isMainPhoto)
                    Text(
                      '(Required)',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  Future<void> _pickImage(int index) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
        maxHeight: 1600,
      );
      
      if (image != null) {
        // Here you would upload the image to Firebase Storage and get the URL
        String imageUrl = await _uploadImageToStorage(image);
        
        final currentImages = List<String>.from(widget.profileImages);
        if (index < currentImages.length) {
          currentImages[index] = imageUrl;
        } else {
          currentImages.add(imageUrl);
        }
        
        final success = await ProfileUpdateService.updateProfileImages(currentImages);
        if (success) {
          widget.onImagesUpdated();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo uploaded successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      String userFriendlyMessage;
      
      if (e.toString().contains('already_active')) {
        userFriendlyMessage = 'Please wait a moment and try again. The image picker is still processing.';
      } else if (e.toString().contains('permission')) {
        userFriendlyMessage = 'Please allow photo access in your device settings to upload photos.';
      } else if (e.toString().contains('cancelled')) {
        userFriendlyMessage = 'Photo selection was cancelled. Please try again.';
      } else {
        userFriendlyMessage = 'Unable to select photo. Please try again or restart the app.';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userFriendlyMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _showImageOptions(BuildContext context, int index) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Photo Options',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.eye, color: theme.colorScheme.primary),
              title: const Text('View Photo'),
              onTap: () {
                Navigator.pop(context);
                _viewImage(index);
              },
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.arrowsRotate, color: Colors.blue),
              title: const Text('Replace Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(index);
              },
            ),
            if (index > 0) // Don't allow deleting main photo
              ListTile(
                leading: FaIcon(FontAwesomeIcons.trash, color: Colors.red),
                title: const Text('Delete Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteImage(index);
                },
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _viewImage(int index) {
    final images = widget.profileImages;
    if (index < images.length) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    images[index],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 40,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.times,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _deleteImage(int index) async {
    final currentImages = List<String>.from(widget.profileImages);
    if (index < currentImages.length) {
      currentImages.removeAt(index);
      
      final success = await ProfileUpdateService.updateProfileImages(currentImages);
      if (success) {
        widget.onImagesUpdated();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete photo. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Placeholder for image upload to Firebase Storage
  Future<String> _uploadImageToStorage(XFile image) async {
    // TODO: Implement Firebase Storage upload
    await Future.delayed(const Duration(seconds: 2)); // Simulate upload time
    return 'https://placeholder.url/image_${DateTime.now().millisecondsSinceEpoch}.jpg';
  }
}
