import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:survey_app/api_service/PublicChatAPIService.dart';
import 'package:survey_app/main.dart';
import 'package:survey_app/model/public_chat/ChatMessage.dart';
import 'package:survey_app/utilities/camera_permission_handler/CameraPermissionHandler.dart';
import 'package:survey_app/utilities/consts.dart';
import 'package:survey_app/utilities/cust_colors.dart';
import 'package:survey_app/utilities/custom_dialog/SnackBarHelper.dart';
import 'package:survey_app/widgets/CustomCircularIndicator.dart';
import 'package:survey_app/widgets/custom_network_image.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:path/path.dart' as p;
import 'package:video_player/video_player.dart';

class PublicChatScreen extends StatefulWidget {
  final WebSocketChannel channel;
  const PublicChatScreen({super.key, required this.channel});

  @override
  State<PublicChatScreen> createState() => _PublicChatScreenState();
}

class _PublicChatScreenState extends State<PublicChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _message = [];
  final Map<String,ValueNotifier<double>> progressValues = {};

  static Uri _wsURL = Uri.parse('ws://truesurvey.in/ws/chat-discussion/');
  late final WebSocketChannel _channel;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasNext = true;
  late final String deviceId;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final TextEditingController _statementController = TextEditingController();
  final FocusNode _statementFocusNode = FocusNode();
  final _messageInputKey = GlobalKey();


  void _fetchMessages() async {
    setState(() {
      _isLoading = true;
    });

    final response = await PublicChatAPIService.getAllPublicChat(
      page: _currentPage.toString(),
    );
    if (response == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final List<ChatMessage> _newMessages = (response['data'] as List)
        .map((json) => ChatMessage.fromJson(json))
        .toList();
    setState(() {
      _message.addAll(_newMessages);
      _isLoading = false;
      _hasNext = response['pagination']['has_next'] ?? false;
      _currentPage++;
    });
  }

  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((duration)async{
  //     _fetchMessages();
  //     try{
  //       final deviceInfo = await deviceInfoPlugin.deviceInfo;
  //       deviceId = deviceInfo.data['id']??'';
  //       _channel = WebSocketChannel.connect(_wsURL);
  //       await _channel.ready;
  //     }catch(exception,trace){
  //       print('Exception: ${exception},Trace: ${trace}');
  //     }
  //   });
  //   _scrollController.addListener(()async{
  //     if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isLoading && _hasNext){
  //       _fetchMessages();
  //     }
  //   });
  //   super.initState();
  // }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fetchMessages();

      try {
        final deviceInfo = await deviceInfoPlugin.deviceInfo;
        deviceId = deviceInfo.data['id'] ?? '';
        _channel = WebSocketChannel.connect(_wsURL);

        // Listen once
        _channel.stream.listen((data) {
          final decoded = json.decode(data) as Map<String, dynamic>;
          if(decoded['event'] == 'deleted'){
            final id = decoded['data']['id'];
            final index = _message.indexWhere((m)=>m.id == id);
            if(index != -1){
              if(mounted){
                setState(() {
                  _message.removeAt(index);
                });
              }
            }
            return;
          }
          final newMsg = ChatMessage.fromJson(decoded['data']);
          if(newMsg.deviceID != deviceId){
            if(mounted)
            setState(() {
              _message.insert(0, newMsg);
            });
          }
        });
      } catch (exception, trace) {
        print('Exception: $exception, Trace: $trace');
      }
    });

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasNext) {
        _fetchMessages();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustColors.background3,
      appBar: AppBar(
        title: Text(
          "Public Chat",
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(color: Colors.white),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(_statementFocusNode);
        },
        child: SafeArea(
          child: Column(
            children: [
              if (_isLoading) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomCircularIndicator(),
                ),
                const SizedBox(height: 4),
                Text('Loading Conversion...'),
              ],
              Expanded(
                child: Stack(
                  children: [
                    _message.isEmpty && !_isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text("No messages yet..."),
                          )
                        : ListView.builder(
                            reverse: true,
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: _message.length + 1,
                            itemBuilder: (context, index) {
                              return Builder(
                                builder: (cardContext) {
                                  if (0 == index) {
                                    final RenderBox box =
                                        _messageInputKey.currentContext!
                                                .findRenderObject()
                                            as RenderBox;
                                    final size = box.size;
                                    return SizedBox(
                                      height: size.height,
                                      width: size.width,
                                    );
                                  }
                                  final msgIndex = index - 1;
                                  return ChatMessageCard(
                                    key: ValueKey(_message[msgIndex].id),
                                    progress: progressValues[_message[msgIndex].id.toString()],
                                    onLongPressed: () async {
                                      // get widget position
                                      var renderBox;
                                      var offset;
                                      try {
                                        renderBox =
                                            cardContext.findRenderObject()
                                                as RenderBox;
                                        offset = renderBox.localToGlobal(
                                          Offset.zero,
                                        );
                                      } catch (exception) {
                                        throw exception;
                                      }

                                      final result = await showMenu<String>(
                                        context: cardContext,
                                        position: RelativeRect.fromLTRB(
                                          offset.dx + renderBox.size.width,
                                          offset.dy, // top position
                                          offset.dx + (renderBox.size.width),
                                          offset.dy + (renderBox.size.height),
                                        ),
                                        items: [
                                          PopupMenuItem(
                                            value: "delete",
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(width: 8),
                                                Text("Delete"),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );

                                      if (result == "delete") {
                                        final tempMsg = _message[msgIndex];
                                        final tempIndex = msgIndex;
                                        if(mounted){
                                          setState(() {
                                            _message.removeAt(msgIndex);
                                          });
                                        }
                                        final isDeleted = await PublicChatAPIService.deleteMessage(messageId: tempMsg.id.toString(), deviceId: deviceId);
                                        if(!isDeleted){
                                          if(mounted){
                                            setState(() {
                                              _message.insert(tempIndex, tempMsg);
                                            });
                                          }
                                        }
                                      }
                                    },
                                    data: _message[msgIndex],
                                    isMe:
                                        deviceId == _message[msgIndex].deviceID,
                                  );
                                },
                              );
                            },
                          ),

                    Positioned(
                      key: _messageInputKey,
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
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 4,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
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
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.shade100,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.attach_file,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          FocusScope.of(
                                            context,
                                          ).requestFocus(_statementFocusNode);
                                          MediaPickerScreen.show(
                                            context,
                                            onSelected: (pickedFile) {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder: (_) => MediaPreviewScreen(
                                                  mediaFiles: [pickedFile],
                                                  onSend: (json) async {
                                                    final statement =
                                                        json['message'] ?? '';
                                                    final xfile =
                                                        json['file'] != null
                                                        ? json['file'] as XFile
                                                        : null;

                                                    final file = xfile != null
                                                        ? File(xfile.path)
                                                        : null;

                                                    // Create temp message
                                                    final tempId = DateTime.now()
                                                        .millisecondsSinceEpoch;
                                                    final tempMsg = ChatMessage(
                                                      id: tempId,
                                                      name:
                                                          prefs.getString(
                                                            Consts.name,
                                                          ) ??
                                                          '',
                                                      statement: statement,
                                                      deviceID: deviceId,
                                                      document: file,
                                                      createdAt:
                                                          "${DateFormat('dd MMM yyyy (hh:mm a)').format(DateTime.now())}",
                                                      createdAgo: null,
                                                      status:
                                                          MessageStatus.sending,
                                                    );

                                                    setState(() {
                                                      _message.insert(
                                                        0,
                                                        tempMsg,
                                                      );
                                                      progressValues[tempId.toString()] = ValueNotifier<double>(0);
                                                    });

                                                    final File? compressedFile = await PublicChatAPIService.compressVideo(file!);
                                                    if(compressedFile == null ){
                                                      final index = _message.indexWhere((m)=> m.deviceID == deviceId && m.id == tempId);
                                                      if(index != -1){
                                                        _message[index].update(status: MessageStatus.failed,);
                                                      }
                                                      return;
                                                    }

                                                   final sessionId = await PublicChatAPIService.createSession(file: compressedFile);
                                                   if(sessionId == null){
                                                     final index = _message.indexWhere((m)=> m.deviceID == deviceId && m.id == tempId);
                                                     if(index != -1){
                                                       if(mounted)
                                                         setState(() {
                                                           _message[index].update(status: MessageStatus.failed,);
                                                         });
                                                     }
                                                     return;
                                                   }

                                                   PublicChatAPIService.uploadFile(sessionId: sessionId,file:compressedFile,onProgress: (progress)async{
                                                     progressValues[tempId.toString()]?.value = progress;
                                                      if(progress == 1){
                                                        final id = await PublicChatAPIService.sendMessageWithFile(statement: statement, deviceId: deviceId, sessionID: sessionId);
                                                        if(id != null){
                                                          final index = _message.indexWhere((m)=> m.deviceID == deviceId && m.id == tempId);
                                                          if(index != -1){
                                                            if(mounted)
                                                              setState(() {
                                                                _message[index].update(status: MessageStatus.sent,id: id);
                                                                progressValues.remove(tempId.toString());
                                                              });
                                                          }
                                                        }else{
                                                          final index = _message.indexWhere((m)=> m.deviceID == deviceId && m.id == tempId);
                                                          if(index != -1){
                                                            if(mounted)
                                                              setState(() {
                                                                _message[index].update(status: MessageStatus.failed,);
                                                              });
                                                          }
                                                        }
                                                      }
                                                    });

                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
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
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  final statement = _statementController.text
                                      .trim();
                                  if (statement.isEmpty) return;
                                  _statementController.clear();

                                  // Create temp message
                                  final tempId =
                                      DateTime.now().millisecondsSinceEpoch;
                                  final tempMsg = ChatMessage(
                                    id: tempId,
                                    name: prefs.getString(Consts.name) ?? '',
                                    statement: statement,
                                    deviceID: deviceId,
                                    createdAt:
                                        "${DateFormat('dd MMM yyyy  (hh:mm a)').format(DateTime.now())}",
                                    createdAgo: null,
                                    status: MessageStatus.sending,
                                  );

                                  setState(() {
                                    _message.insert(0, tempMsg);
                                  });

                                  // Send to API
                                  final id =
                                      await PublicChatAPIService.sendMessageWithoutFile(
                                        statement: statement,
                                        deviceId: deviceId,
                                      );

                                  if(id != null){
                                    final tempIndex = _message.indexWhere(
                                          (m) =>
                                      m.deviceID == tempMsg.deviceID &&
                                          m.id == tempMsg.id &&
                                          (m.statement == tempMsg.statement || m.document == tempMsg.document) &&
                                          m.status == MessageStatus.sending,
                                    );

                                    if (tempIndex != -1) {
                                      setState(() {
                                        _message[tempIndex].update(id:id,status: MessageStatus.sent,);
                                      });
                                    }

                                  }else {
                                    setState(() {
                                      final index = _message.indexWhere(
                                        (m) => m.id == tempId,
                                      );
                                      if (index != -1) {
                                        _message[index].update(status: MessageStatus.failed);
                                      }
                                    });
                                  }
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
            ],
          ),
        ),
      ),
    );

    // return Dialog(
    //   insetPadding: const EdgeInsets.all(20),
    //   backgroundColor: Colors.white,
    //   child: SizedBox(
    //     width: 400,
    //     height: 500,
    //     child: Column(
    //       children: [
    //         // Header
    //         Container(
    //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    //           color: Colors.blue,
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               const Text(
    //                 "Public Chat",
    //                 style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    //               ),
    //               GestureDetector(
    //                 onTap: () => Navigator.of(context).pop(),
    //                 child: Container(
    //                   decoration: BoxDecoration(
    //                     color: Colors.red,
    //                     borderRadius: BorderRadius.circular(4),
    //                   ),
    //                   padding: const EdgeInsets.all(4),
    //                   child: const Icon(Icons.close, size: 16, color: Colors.white),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //
    //         // Chat area (can be a ListView)
    //
    //         if(_isLoading)...[
    //           Padding(
    //             padding: const EdgeInsets.symmetric(vertical: 8.0),
    //             child: CustomCircularIndicator(),
    //           ),
    //           const SizedBox(height: 4,),
    //           Text('Loading Conversion...')
    //         ],
    //         Expanded(
    //           child: _message.isEmpty && !_isLoading ? const Padding(
    //             padding: EdgeInsets.all(16),
    //             child: Text("No messages yet..."),
    //           ):ListView.builder(
    //               reverse: true,
    //               controller: _scrollController,
    //               shrinkWrap: true,
    //               itemCount: _message.length,
    //               itemBuilder: (context,index){
    //                 return Builder(
    //                   builder: (cardContext){
    //                     return ChatMessageCard(
    //                       onLongPressed: ()async{
    //                         // get widget position
    //                         var renderBox;
    //                         var offset;
    //                         try{
    //                           renderBox = cardContext.findRenderObject() as RenderBox;
    //                           offset = renderBox.localToGlobal(Offset.zero);
    //                         }catch(exception){
    //                           throw exception;
    //                         }
    //
    //                         final result = await showMenu<String>(
    //                           context: cardContext,
    //                           position: RelativeRect.fromLTRB(
    //                             offset.dx + renderBox.size.width,
    //                             offset.dy, // top position
    //                             offset.dx + (renderBox.size.width ),
    //                             offset.dy + (renderBox.size.height),
    //                           ),
    //                           items: [
    //                             PopupMenuItem(
    //                               value: "delete",
    //                               child: Row(
    //                                 children: [
    //                                   Icon(Icons.delete, color: Colors.red),
    //                                   SizedBox(width: 8),
    //                                   Text("Delete"),
    //                                 ],
    //                               ),
    //                             ),
    //                           ],
    //                         );
    //
    //                         if (result == "delete") {
    //                           ScaffoldMessenger.of(context).showSnackBar(
    //                             SnackBar(content: Text("Message deleted")),
    //                           );
    //                         }
    //                       },
    //                       data: _message[index],
    //                       isMe: deviceId == _message[index].deviceID,
    //                     );
    //                   },
    //                 );
    //               }
    //           ),
    //         ),
    //
    //
    //
    //         // Expanded(
    //         //   child: FutureBuilder<Map<String,dynamic>?>(
    //         //       future: _PublicChatBackend.getAllPublicChat(page: '1'),
    //         //       builder: (context,snapshot){
    //         //         if(snapshot.connectionState == ConnectionState.waiting){
    //         //           return CustomCircularIndicator();
    //         //         }
    //         //         if(snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty){
    //         //
    //         //           return ListView.builder(
    //         //             shrinkWrap: true,
    //         //               itemCount: 2,
    //         //               itemBuilder: (context,index){
    //         //               return ChatMessageCard(
    //         //                 data: {
    //         //                   "id": 5,
    //         //                   "name": null,
    //         //                   "statement": "HII GAUAV",
    //         //                   "document": null,
    //         //                   "device_id": "fe819341-7338-4168-903a-5503379643ec",
    //         //                   "created_at": "22 Aug 2025",
    //         //                   "created_ago": "1 week ago"
    //         //                 },
    //         //                 isMe: index == 0,
    //         //               );
    //         //               }
    //         //           );
    //         //         }else{
    //         //          return const Padding(
    //         //            padding: EdgeInsets.all(16),
    //         //            child: Text("No messages yet..."), // Replace with ListView.builder later
    //         //          );
    //         //         }
    //         //       }
    //         //   ),
    //         // ),
    //
    //         // Message input area
    //         Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    //           child: Row(
    //             children: [
    //               Expanded(
    //                 child: Container(
    //                   decoration: BoxDecoration(
    //                     border: Border.all(color: Colors.grey.shade400),
    //                     borderRadius: BorderRadius.circular(8),
    //                   ),
    //                   child: TextField(
    //                     controller: _statementController,
    //                     decoration: InputDecoration(
    //                       hintText: 'Type message...',
    //                       border: InputBorder.none,
    //                       filled: false,
    //                       focusedBorder: InputBorder.none,
    //                       enabledBorder: InputBorder.none
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               const SizedBox(width: 8),
    //               IconButton(
    //                 icon: const Icon(Icons.attach_file, color: Colors.grey),
    //                 onPressed: () {
    //                   // TODO: Add file picker
    //                 },
    //               ),
    //               IconButton(
    //                 icon: const Icon(Icons.send, color: Colors.blue),
    //                   onPressed: () async {
    //                     final statement = _statementController.text.trim();
    //                     if (statement.isEmpty) return;
    //                     _statementController.clear();
    //
    //                     // Create temp message
    //                     final tempId = DateTime.now().millisecondsSinceEpoch;
    //                     final tempMsg = ChatMessage(
    //                       id: tempId,
    //                       name: prefs.getString(Consts.name)??'',
    //                       statement: statement,
    //                       deviceID: deviceId,
    //                       createdAt: "${DateFormat('dd MMM yyyy').format(DateTime.now())}",
    //                       createdAgo: "just now",
    //                       status: MessageStatus.sending,
    //                     );
    //
    //                     setState(() {
    //                       _message.insert(0, tempMsg);
    //                     });
    //
    //                     // Send to API
    //                     final isSent = await _PublicChatBackend.sendMessage(
    //                       statement: statement,
    //                       deviceId: deviceId,
    //                     );
    //
    //                     if (!isSent) {
    //                       // Mark as failed
    //                       setState(() {
    //                         final index = _message.indexWhere((m) => m.id == tempId);
    //                         if (index != -1) {
    //                           _message[index].status = MessageStatus.failed;
    //                         }
    //                       });
    //                     }
    //                   }
    //                 // onPressed: () async {
    //                 //   final statement = _statementController.text.trim();
    //                 //   if (statement.isEmpty) return;
    //                 //
    //                 //   // Clear input
    //                 //   _statementController.clear();
    //                 //
    //                 //   // 1. Create a temporary message for immediate UI
    //                 //   final tempMsg = ChatMessage(
    //                 //     id: DateTime.now().millisecondsSinceEpoch, // unique temp id
    //                 //     statement: statement,
    //                 //     deviceID: deviceId,
    //                 //     createdAt: DateTime.now().toIso8601String(),
    //                 //     createdAgo: "just now",
    //                 //   );
    //                 //
    //                 //   setState(() {
    //                 //     _message.insert(0, tempMsg);
    //                 //   });
    //                 //
    //                 //   // 2. Send via socket
    //                 //   _channel.sink.add(jsonEncode({
    //                 //     "action": "send_message",
    //                 //     "data": {
    //                 //       "statement": statement,
    //                 //       "device_id": deviceId,
    //                 //     }
    //                 //   }));
    //                 //
    //                 //   // 3. Send via REST API (for saving in DB)
    //                 //   final isSent = await _PublicChatBackend.sendMessage(
    //                 //     statement: statement,
    //                 //     deviceId: deviceId,
    //                 //   );
    //                 //
    //                 //   if (!isSent) {
    //                 //     // Optionally show failed message feedback
    //                 //     ScaffoldMessenger.of(context).showSnackBar(
    //                 //       SnackBar(content: Text("Failed to send")),
    //                 //     );
    //                 //   }
    //                 // },
    //               ),
    //
    //               // IconButton(
    //               //   icon: const Icon(Icons.send, color: Colors.blue),
    //               //   onPressed: ()async{
    //               //     final statement = _statementController.text;
    //               //     _statementController.text = '';
    //               //     // _fetchMessages();
    //               //     final isSent = await _PublicChatBackend.sendMessage(statement: statement, deviceId: deviceId);
    //               //     if(isSent){
    //               //       _message.clear();
    //               //     }
    //               //   },
    //               // ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

  }

  @override
  void dispose() {
    _scrollController.dispose();
    widget.channel.sink.close(1000, 'NORMAL_CLOSER');
    _statementController.dispose();
    _statementFocusNode.unfocus();
    super.dispose();
  }

}

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

