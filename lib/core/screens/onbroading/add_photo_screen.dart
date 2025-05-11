import 'package:app/apis/services/media_service.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_decoration.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../token/padding_tokens.dart';
import '../../token/border_radius_tokens.dart';


// Function to show image picking options
void showPhotoPickerSheet(
    BuildContext context, {
      required Function(File) onImagePicked,
    }) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () async {
                Navigator.pop(context);
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(source: ImageSource.camera);
                if (image != null) onImagePicked(File(image.path));
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Choose from gallery'),
              onTap: () async {
                Navigator.pop(context);
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) onImagePicked(File(image.path));
              },
            ),
          ],
        ),
      );
    },
  );
}

class PhotoTab extends StatefulWidget {
  final VoidCallback onContinue;
  final Function(List<String>) onPhotosChanged;
  final List<String> initialPhotos;

  const PhotoTab({
    Key? key,
    required this.onContinue,
    required this.onPhotosChanged,
    required this.initialPhotos,
  }) : super(key: key);

  @override
  State<PhotoTab> createState() => _PhotoTabState();
}

class _PhotoTabState extends State<PhotoTab> {
  late List<String?> photos;
  final MediaService _avatarProfileService = MediaService();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    // Initialize with existing photos if any, otherwise create empty slots
    photos =
    widget.initialPhotos.isNotEmpty
        ? List<String?>.from(widget.initialPhotos.map((p) => p).toList())
        : List.generate(6, (index) => null);

    // If the list is shorter than 6, pad it with nulls
    while (photos.length < 6) {
      photos.add(null);
    }
  }

  void _addPhoto(int index, String path) {
    setState(() {
      photos[index] = path;
      _updatePhotosList();
    });
  }

  void _removePhoto(int index) {
    setState(() {
      photos[index] = null;
      _updatePhotosList();
    });
  }

  void _updatePhotosList() {
    final nonNullPhotos =
    photos.where((p) => p != null).map((p) => p!).toList();
    widget.onPhotosChanged(nonNullPhotos);
  }

  // Method to upload avatar photos
  Future<void> _uploadAvatarPhotos() async {
    if (_isUploading) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // Get list of selected image files
      final imagePaths = photos
          .where((p) => p != null)
          .map((path) => path!)
          .toList();

      if (imagePaths.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one photo')),
        );
        return;
      }

      // Upload each image and save returned URLs
      List<String> uploadedUrls = [];
      for (final path in imagePaths) {
        await _avatarProfileService.uploadAvatar(path);
      }

      // Update the list of uploaded image URLs
      widget.onPhotosChanged(uploadedUrls);

      // Move to next screen
      widget.onContinue();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading photos: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = photos.where((p) => p != null).length;
    return Padding(
      padding: EdgeInsets.all(AppPaddingTokens.paddingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add photos', style: AppTheme.headLineLarge32),
          const SizedBox(height: AppPaddingTokens.paddingMd),
          Text(
            'Add at least 1 photo to continue',
            style: AppTheme.bodySmall12.copyWith(
              color: AppColors.neutralGray600,
            ),
          ),
          const SizedBox(height: AppPaddingTokens.paddingMd),
          Expanded(
            child: GridView.builder(
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final imagePath = photos[index];
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppBorderRadiusTokens.borderRadiusMedium,
                        ),
                        color: AppColors.neutralGray200,
                      ),
                      alignment: Alignment.center,
                      child:
                      imagePath != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      )
                          : IconButton(
                        onPressed: () {
                          showPhotoPickerSheet(
                            context,
                            onImagePicked:
                                (file) => _addPhoto(index, file.path),
                          );
                        },
                        icon: Icon(
                          Icons.add,
                          color: AppColors.redRed400,
                        ),
                      ),
                    ),
                    if (imagePath != null)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removePhoto(index),
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppPaddingTokens.paddingMd),
          _buildContinueButton(selectedCount),
          if (_isUploading)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.redRed400,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Build the continue button inside the _PhotoTabState class
  Widget _buildContinueButton(int selectedCount) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        AppBorderRadiusTokens.borderRadiusLarge,
      ),
      child: InkWell(
        onTap: (selectedCount >= 1 && !_isUploading) ? () {
          // Update photos list one final time
          _updatePhotosList();
          // Upload photos and then continue
          _uploadAvatarPhotos();
        } : null,
        child: Container(
          height: 50,
          width: double.infinity,
          decoration:
          (selectedCount >= 1 && !_isUploading)
              ? AppDecoration.createAccountButton()
              : BoxDecoration(
            color: AppColors.neutralGray300,
            borderRadius: BorderRadius.circular(
              AppBorderRadiusTokens.borderRadiusLarge,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            'CONTINUE',
            style: AppTheme.titleSmall16.copyWith(
              color:
              (selectedCount >= 1 && !_isUploading) ? AppColors.primaryWhite : AppColors.neutralGray600,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}