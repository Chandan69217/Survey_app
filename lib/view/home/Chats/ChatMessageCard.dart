import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:survey_app/model/chat_model/ChatMessage.dart';
import 'package:survey_app/utilities/consts.dart';
import 'package:survey_app/view/home/Chats/OpenMediaScreen.dart';
import 'package:survey_app/widgets/CustomCircularIndicator.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as p;

class ChatMessageCard extends StatefulWidget {
  final ChatMessage data;
  final bool isMe;
  final VoidCallback? onLongPressed;
  final ValueNotifier<double>? progress;
  const ChatMessageCard({
    Key? key,
    required this.data,
    this.isMe = false,
    this.onLongPressed,
    this.progress,
  }) : super(key: key);

  @override
  State<ChatMessageCard> createState() => _ChatMessageCardState();
}

class _ChatMessageCardState extends State<ChatMessageCard> {
  VideoPlayerController? _videoPlayerController;
  String? _filePath;
  bool get _isVideo {
    if (_filePath == null) return false;
    final ext = p.extension(_filePath!).toLowerCase();
    return Consts.allowedVideos.contains(ext);
  }

  bool get _isImage {
    if (_filePath == null) return false;
    final ext = p.extension(_filePath!).toLowerCase();
    return Consts.allowedImages.contains(ext);
  }

  @override
  void initState() {
    super.initState();
    if(widget.progress != null){
      print('Progress bar received');
    }
    if (widget.data.document != null) {
      if (widget.data.document is File) {
        _filePath = (widget.data.document as File).path;
        _initVideoController(File(_filePath!));
      } else if (widget.data.document is String) {
        _filePath = widget.data.document as String;
        _initVideoController(_filePath);
      }
    }
  }

  void _initVideoController(dynamic source) {
    if (!_isVideo) return;

    if (source is File) {
      _videoPlayerController = VideoPlayerController.file(source);
    } else if (source is String) {
      if (source.startsWith("http")) {
        _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(source));
      } else {
        _videoPlayerController = VideoPlayerController.file(File(source));
      }
    }

    _videoPlayerController?.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Widget _buildMedia() {
    if (_filePath == null) return const SizedBox.shrink();

    final borderRadius = BorderRadius.circular(12);

    if (_isVideo && _videoPlayerController != null) {
      return GestureDetector(
        onTap: (){
          showDialog(
            context: context,
            builder: (_) => OpenMediaScreen(
              media: widget.data.document,
              isVideo: _isVideo,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 250,
                minHeight: 160,
              ),
              color: Colors.black,
              child: _videoPlayerController!.value.isInitialized
                  ? Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _videoPlayerController!.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController!),
                  ),
                  widget.progress != null ?
                  ValueListenableBuilder<double>(
                    valueListenable: widget.progress!,
                    builder: (context,progress,child)=> CustomCircularIndicator(value: progress,colors: [Colors.white,Colors.white70,],),
                  )  :
                  Icon(
                    Icons.play_circle_fill,
                    size: 48,
                    color: Colors.white70,
                  ),
                ],
              )
                  : CustomCircularIndicator(
                colors: [Colors.white,Colors.white70],
              ),
            ),
          ),
        ),
      );
    }

    if (_isImage) {
      return GestureDetector(
        onTap: (){
          showDialog(
            context: context,
            useSafeArea: true,
            builder: (_) => OpenMediaScreen(
              media: widget.data.document,
              isVideo: _isVideo,
            ),
          );

        },
        child: Padding(
          padding: EdgeInsetsGeometry.only(top: 6.0),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: 250,
                      minHeight: 160,
                    ),
                    color: Colors.black12,
                    child: _filePath!.startsWith("http")
                        ? CachedNetworkImage(
                      imageUrl: _filePath!,
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/Placeholder_image.webp',),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2,color: Colors.white,),
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 40),
                    )
                        : Image.file(
                      File(_filePath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  widget.progress != null ?
                  ValueListenableBuilder<double>(
                    valueListenable: widget.progress!,
                    builder: (context,progress,child)=> CustomCircularIndicator(value: progress,colors: [Colors.white,Colors.white70,],),
                  )  : SizedBox.shrink()
                ]
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: widget.onLongPressed,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: widget.isMe ? Colors.teal : Colors.grey.shade200,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: widget.isMe
                  ? const Radius.circular(16)
                  : const Radius.circular(0),
              bottomRight: widget.isMe
                  ? const Radius.circular(0)
                  : const Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (widget.data.name != null)
                Text(
                  widget.data.name!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: widget.isMe ? Colors.white70 : Colors.black54,
                  ),
                ),

              // Media preview (image/video)
              _buildMedia(),

              // Message text
              if (widget.data.statement?.isNotEmpty ?? false)
                Text(
                  widget.data.statement!,
                  style: TextStyle(
                    fontSize: 15,
                    color: widget.isMe ? Colors.white : Colors.black87,
                  ),
                ),

              const SizedBox(height: 6),

              // Time + Status
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.data.createdAt ?? "",
                    style: TextStyle(
                      fontSize: 11,
                      color: widget.isMe ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  if (widget.data.createdAgo != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      "(${widget.data.createdAgo})",
                      style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: widget.isMe ? Colors.white70 : Colors.black45,
                      ),
                    ),
                  ],
                  if (widget.isMe) ...[
                    const SizedBox(width: 8),
                    if (widget.data.status == MessageStatus.sending)
                      const Icon(Icons.schedule, size: 14, color: Colors.white70),
                    if (widget.data.status == MessageStatus.sent)
                      const Icon(Icons.check, size: 14, color: Colors.white70),
                    if (widget.data.status == MessageStatus.failed)
                      const Icon(Icons.error, size: 14, color: Colors.red),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}