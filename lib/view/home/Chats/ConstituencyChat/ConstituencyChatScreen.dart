import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/api_service/ConstituencyChatAPIService.dart';
import 'package:survey_app/api_service/PublicChatAPIService.dart';
import 'package:survey_app/main.dart';
import 'package:survey_app/model/AppUser.dart';
import 'package:survey_app/model/LoginUser.dart';
import 'package:survey_app/model/chat_model/ChatMessage.dart';
import 'package:survey_app/utilities/consts.dart';
import 'package:survey_app/utilities/cust_colors.dart';
import 'package:survey_app/view/home/Chats/ChatMessageCard.dart';
import 'package:survey_app/view/home/Chats/MediaPickerScreen.dart';
import 'package:survey_app/view/home/Chats/MediaPreviewScreen.dart';
import 'package:survey_app/widgets/CustomCircularIndicator.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ConstituencyChatScreen extends StatefulWidget {
  final String constituencyId;
  const ConstituencyChatScreen({super.key,required this.constituencyId});

  @override
  State<ConstituencyChatScreen> createState() => _ConstituencyChatScreenState();

}


class _ConstituencyChatScreenState extends State<ConstituencyChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _message = [];
  final Map<String,ValueNotifier<double>> progressValues = {};

  late final WebSocketChannel _channel;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasNext = true;
  late final String deviceId;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final TextEditingController _statementController = TextEditingController();
  final FocusNode _statementFocusNode = FocusNode();
  final _messageInputKey = GlobalKey();
  late final String userPhoneNumber;
  void _fetchMessages() async {
    setState(() {
      _isLoading = true;
    });

    final response = await ConstituencyChatAPIService.getAllConstituencyChat(
      constituencyId: widget.constituencyId,
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
      _hasNext = response['pagination']?['has_next'] ?? false;
      _currentPage++;
    });
  }


  @override
  void initState() {
    super.initState();
    userPhoneNumber = prefs.getString(Consts.phoneNumber)??'';
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fetchMessages();

      try {
        final deviceInfo = await deviceInfoPlugin.deviceInfo;
        deviceId = deviceInfo.data['id'] ?? '';
        final accessToken = prefs.getString(Consts.accessToken)??'';
        // final wsUrl = Uri.parse('ws://truesurvey.in/ws/chat-discussion-constituency/${widget.constituencyId}/?token=${accessToken}');
        // _channel = WebSocketChannel.connect(wsUrl);

        // Listen once
        // _channel.stream.listen((data) {
        //   final decoded = json.decode(data) as Map<String, dynamic>;
        //   if(decoded['event'] == 'deleted'){
        //     final id = decoded['data']['id'];
        //     final index = _message.indexWhere((m)=>m.id == id);
        //     if(index != -1){
        //       if(mounted){
        //         setState(() {
        //           _message.removeAt(index);
        //         });
        //       }
        //     }
        //     return;
        //   }
        //   final newMsg = ChatMessage.fromJson(decoded['data']);
        //   if(newMsg.deviceID != deviceId){
        //     if(mounted)
        //     setState(() {
        //       _message.insert(0, newMsg);
        //     });
        //   }
        // });
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
        title: Consumer<LoginUser>(
          builder:(context,loginUser,child)=> Text(
            loginUser.constituencyName != null && loginUser.constituencyName?.name != null ? '${loginUser.constituencyName?.name} Chat':"Constituency Chat",
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(color: Colors.white),
          ),
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
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      _message.isEmpty && !_isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: Text("No messages yet...")),
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
                                      onLongPressed: (_message[msgIndex].addedBy?.phone??'') == userPhoneNumber && userPhoneNumber.isNotEmpty? () async {
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
                                          final isDeleted = await ConstituencyChatAPIService.deleteMessage(constituencyID: widget.constituencyId,messageId: tempMsg.id.toString(), deviceId: deviceId);
                                          if(!isDeleted){
                                            if(mounted){
                                              setState(() {
                                                _message.insert(tempIndex, tempMsg);
                                              });
                                            }
                                          }
                                        }
                                      } : null,
                                      data: _message[msgIndex],
                                      isMe: (_message[msgIndex].addedBy?.phone??'') == userPhoneNumber && userPhoneNumber.isNotEmpty
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
                                                      final AddedBy addedBy = AddedBy(
                                                        name: prefs.getString(Consts.name),
                                                        phone: userPhoneNumber,
                                                        photo: prefs.getString(Consts.photo),
                                                      );
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
                                                        addedBy: addedBy,
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

                                                      final File? compressedFile = await ConstituencyChatAPIService.compressVideo(file!);
                                                      if(compressedFile == null ){
                                                        final index = _message.indexWhere((m)=> m.deviceID == deviceId && m.id == tempId);
                                                        if(index != -1){
                                                          _message[index].update(status: MessageStatus.failed,);
                                                        }
                                                        return;
                                                      }

                                                     final sessionId = await ConstituencyChatAPIService.createSession(file: compressedFile);
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

                                                     ConstituencyChatAPIService.uploadFile(sessionId: sessionId,file:compressedFile,onProgress: (progress)async{
                                                       progressValues[tempId.toString()]?.value = progress;
                                                        if(progress == 1){
                                                          final id = await ConstituencyChatAPIService.sendMessageWithFile(constituencyId: widget.constituencyId,statement: statement, deviceId: deviceId, sessionID: sessionId);
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
                                    final AddedBy addedBy = AddedBy(
                                      name: prefs.getString(Consts.name),
                                      phone: userPhoneNumber,
                                      photo: prefs.getString(Consts.photo),
                                    );
                                    // Create temp message
                                    final tempId =
                                        DateTime.now().millisecondsSinceEpoch;
                                    final tempMsg = ChatMessage(
                                      id: tempId,
                                      name: prefs.getString(Consts.name) ?? '',
                                      statement: statement,
                                      deviceID: deviceId,
                                      addedBy: addedBy,
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
                                        await ConstituencyChatAPIService.sendMessageWithoutFile(
                                          constituencyId: widget.constituencyId,
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
              ),
            ],
          ),
        ),
      ),
    );


  }

  @override
  void dispose() {
    _scrollController.dispose();
    // _channel.sink.close(1000, 'NORMAL_CLOSER');
    _statementController.dispose();
    _statementFocusNode.unfocus();
    super.dispose();
  }

}













