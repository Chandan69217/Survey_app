import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:survey_app/utilities/camera_permission_handler/CameraPermissionHandler.dart';



class ChooseFile{
  ChooseFile._();
  static Future<void> showImagePickerBottomSheet(
      BuildContext context,
      void Function(File imageFile) onImagePicked,
      ) async {
    final ImagePicker _picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose Image Source',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  final cameraPermission = await handleCameraPermission(context);
                  if(!cameraPermission){
                    return;
                  }
                  try {
                    final XFile? photo = await _picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                      preferredCameraDevice: CameraDevice.rear,
                    );
                    if (photo != null) {
                      final File imageFile = File(photo.path);
                      onImagePicked(imageFile);
                    }
                  } catch (e) {
                    debugPrint('Camera error: $e');
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final result = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (result != null) {
                      final File imageFile = File(result.path!);
                      onImagePicked(imageFile);
                    }
                  } catch (e) {
                    debugPrint('Gallery error: $e');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}