import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:survey_app/utilities/consts.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as p;

class MediaPreviewScreen extends StatefulWidget {
  final List<XFile> mediaFiles;
  final Function(Map<String, dynamic>)? onSend;
  const MediaPreviewScreen({
    super.key,
    required this.mediaFiles,
    this.onSend,
  });

  @override
  State<MediaPreviewScreen> createState() =>
      _MediaPreviewScreenState();
}

class _MediaPreviewScreenState extends State<MediaPreviewScreen> {
  final PageController _pageController = PageController();
  late List<VideoPlayerController?> _videoControllers;
  final TextEditingController _statementController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _videoControllers = widget.mediaFiles.map((file) {
      final ext = p.extension(file.path).toLowerCase();
      if (Consts.allowedVideos.contains(ext)) {
        final controller = VideoPlayerController.file(File(file.path))
          ..initialize().then((_) {
            if (mounted) setState(() {});
          });
        return controller;
      }
      return null;
    }).toList();
  }

  @override
  void dispose() {
    _statementController.dispose();
    for (var vc in _videoControllers) {
      vc?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.mediaFiles.length,
                    itemBuilder: (context, index) {
                      final file = widget.mediaFiles[index];
                      if (_videoControllers[index] != null) {
                        final controller = _videoControllers[index]!;
                        return controller.value.isInitialized
                            ? AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              VideoPlayer(controller),
                              IconButton(
                                icon: Icon(
                                  controller.value.isPlaying
                                      ? Icons.pause_circle
                                      : Icons.play_circle,
                                  color: Colors.white,
                                  size: 48,
                                ),
                                onPressed: () {
                                  setState(() {
                                    controller.value.isPlaying
                                        ? controller.pause()
                                        : controller.play();
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                            : const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      } else {
                        return Image.file(File(file.path), fit: BoxFit.contain);
                      }
                    },
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Iconsax.close_circle_copy, color: Colors.white),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade200),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: TextField(
                              autofocus: false,
                              controller: _statementController,
                              decoration: InputDecoration(
                                hintText: 'Type message...',
                                border: InputBorder.none,
                                filled: false,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              final statement = _statementController.text;
                              final data = {
                                'message': statement,
                                'file': widget.mediaFiles[0],
                              };
                              widget.onSend?.call(data);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}