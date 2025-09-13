import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:survey_app/utilities/camera_permission_handler/CameraPermissionHandler.dart';
import 'package:survey_app/utilities/consts.dart';
import 'package:path/path.dart' as p;
import 'package:survey_app/utilities/custom_dialog/SnackBarHelper.dart';
import 'package:video_player/video_player.dart';



class MediaPickerScreen {
  static Future<void> show(
      BuildContext context, {
        Function(XFile file)? onSelected,
      }) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _mediaOption(
                    icon: Icons.photo_library,
                    label: "Photo",
                    color: Colors.blue,
                    onTap: () async {
                      Navigator.pop(context);
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (pickedFile != null) {
                        final ext = p.extension(pickedFile.path).toLowerCase();
                        if (Consts.allowedImages.contains(ext)) {
                          onSelected?.call(pickedFile);
                        } else {
                          SnackBarHelper.show(
                            context,
                            'Invalid file type: $ext. Only JPG/JPEG or PNG allowed.',
                          );
                        }
                      }
                    },
                  ),
                  _mediaOption(
                    icon: Icons.video_library,
                    label: "Video",
                    color: Colors.red,
                    onTap: () async {
                      Navigator.pop(context);
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickVideo(
                        source: ImageSource.gallery,
                        maxDuration: Duration(seconds: 15),
                      );
                      if (pickedFile != null) {
                        final controller = VideoPlayerController.file(
                          File(pickedFile.path),
                        );
                        await controller.initialize();
                        final duration = controller.value.duration;
                        if (duration.inSeconds > 15) {
                          SnackBarHelper.show(
                            context,
                            "Video too long, only 15 sec allowed.",
                          );
                          controller.dispose();
                          return;
                        }
                        controller.dispose();
                        final ext = p.extension(pickedFile.path).toLowerCase();
                        if (Consts.allowedVideos.contains(ext)) {
                          onSelected?.call(pickedFile);
                        } else {
                          SnackBarHelper.show(
                            context,
                            'Invalid file type: $ext. Only MP4 allowed.',
                          );
                        }
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _mediaOption(
                    icon: Icons.camera_alt,
                    label: "Camera",
                    color: Colors.green,
                    onTap: () async {
                      Navigator.pop(context);
                      final permission = await handleCameraPermission(context);
                      if (!permission) {
                        SnackBarHelper.show(
                          context,
                          '"Camera permission is required to continue.',
                        );
                        return;
                      }
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickImage(
                        source: ImageSource.camera,
                      );
                      if (pickedFile != null) {
                        onSelected?.call(pickedFile);
                      }
                    },
                  ),
                  _mediaOption(
                    icon: Icons.videocam,
                    label: "Record",
                    color: Colors.orange,
                    onTap: () async {
                      Navigator.pop(context);
                      final permission = await handleCameraPermission(context);
                      if (!permission) {
                        SnackBarHelper.show(
                          context,
                          '"Camera permission is required to continue.',
                        );
                        return;
                      }
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickVideo(
                        source: ImageSource.camera,
                        maxDuration: Duration(seconds: 15),
                      );
                      if (pickedFile != null) {
                        onSelected?.call(pickedFile);
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  static Widget _mediaOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, size: 28, color: color),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}