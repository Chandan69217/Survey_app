import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class OpenMediaScreen extends StatefulWidget {
  final dynamic media; // File or String (url)
  final bool isVideo;

  const OpenMediaScreen({
    super.key,
    required this.media,
    required this.isVideo,
  });

  @override
  State<OpenMediaScreen> createState() => _OpenMediaScreenState();
}

class _OpenMediaScreenState extends State<OpenMediaScreen> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();

    if (widget.isVideo) {
      if (widget.media is File) {
        _videoController = VideoPlayerController.file(widget.media);
      } else if (widget.media is String) {
        _videoController =
            VideoPlayerController.networkUrl(Uri.parse(widget.media));
      }

      _videoController?.initialize().then((_) {
        if (mounted) setState(() {});
        _videoController?.play();
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Stack(
        children: [

          InteractiveViewer(
            minScale: 0.8,
            maxScale: 4.0,
            panEnabled: true,
            child: Center(
              child: widget.isVideo
                  ? (_videoController != null &&
                  _videoController!.value.isInitialized)
                  ? AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              )
                  : const CircularProgressIndicator(color: Colors.white)
                  : widget.media is File
                  ? Image.file(widget.media, fit: BoxFit.contain)
                  : CachedNetworkImage(
                imageUrl: widget.media!,
                fit: BoxFit.contain,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Placeholder_image.webp',),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2,color: Colors.white,),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 40),
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }


}