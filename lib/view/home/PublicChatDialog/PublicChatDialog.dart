import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:survey_app/api_service/api_urls.dart';
import 'package:survey_app/main.dart';
import 'package:survey_app/model/AppUser.dart';
import 'package:survey_app/model/public_chat/ChatMessage.dart';
import 'package:survey_app/utilities/consts.dart';
import 'package:survey_app/widgets/CustomCircularIndicator.dart';
import 'package:web_socket_channel/web_socket_channel.dart';




class PublicChatDialog extends StatefulWidget {
  final WebSocketChannel channel;
  const PublicChatDialog({super.key,required this.channel});

  @override
  State<PublicChatDialog> createState() => _PublicChatDialogState();
}

class _PublicChatDialogState extends State<PublicChatDialog> {
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _message = [];
  // static  Uri _wsURL = Uri.parse('ws://truesurvey.in/ws/chat-discussion/');
  // late final WebSocketChannel _channel;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasNext = true;
  late final String deviceId;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final TextEditingController _statementController = TextEditingController();

  void _fetchMessages()async{
    setState(() {
      _isLoading = true;
    });
    final response = await _PublicChatBackend.getAllPublicChat(page: _currentPage.toString());
    if(response == null){
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final List<ChatMessage> _newMessages = (response['data'] as List).map((json)=>ChatMessage.fromJson(json)).toList();
    setState(() {
      _message.addAll(_newMessages);
      _isLoading = false;
      _hasNext = response['pagination']['has_next']??false;
      _currentPage++;
    });
  }

  void init()async{
    try{
      await widget.channel.ready;

      widget.channel.stream.listen(
            (event) {
          print("📩 Message: $event");
        },
       
        onError: (error) {
          print("⚠️ WebSocket error: $error");
        },
        onDone: () {
          print("❌ Connection closed with code: ${widget.channel.closeCode}");
        },
      );
    }catch(exception){
      print('Exception: $exception');
    }
  }
  @override
  void initState() {
     // init();
    WidgetsBinding.instance.addPostFrameCallback((duration)async{


      _fetchMessages();
      try{
        final deviceInfo = await deviceInfoPlugin.deviceInfo;
        deviceId = deviceInfo.data['id']??'';
        // _channel = WebSocketChannel.connect(wsURL);
        // await _channel.ready;

        // _channel.stream.listen((value)async{
        //   print(value);
        // });
      }catch(exception,trace){
        print('Exception: ${exception},Trace: ${trace}');
      }
    });
    _scrollController.addListener(()async{
      if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isLoading && _hasNext){
        _fetchMessages();
      }
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 400,
        height: 500,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Public Chat",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // Chat area (can be a ListView)

            if(_isLoading)...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CustomCircularIndicator(),
              ),
              const SizedBox(height: 4,),
              Text('Loading Conversion...')
            ],
            // Expanded(
            //   child: StreamBuilder(
            //     stream: widget.channel.stream,
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return const Center(child: CircularProgressIndicator());
            //       }
            //       if (snapshot.hasError) {
            //         return Center(child: Text("⚠️ Error: ${snapshot.error}"));
            //       }
            //       if (!snapshot.hasData) {
            //         return const Center(child: Text("No messages yet..."));
            //       }
            //       return ListView(
            //         children: [
            //           Text("📩 ${snapshot.data}"),
            //         ],
            //       );
            //     },
            //   ),
            // ),

            Expanded(
                child: _message.isEmpty && !_isLoading ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("No messages yet..."), // Replace with ListView.builder later
                ):ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: _message.length,
                    itemBuilder: (context,index){
                      return Builder(
                      builder: (cardContext){
                        return ChatMessageCard(
                          onLongPressed: ()async{
                            // get widget position
                            var renderBox;
                            var offset;
                            try{
                              renderBox = cardContext.findRenderObject() as RenderBox;
                              offset = renderBox.localToGlobal(Offset.zero);
                            }catch(exception){
                              throw exception;
                            }

                            final result = await showMenu<String>(
                              context: cardContext,
                              position: RelativeRect.fromLTRB(
                                offset.dx + renderBox.size.width,
                                offset.dy, // top position
                                offset.dx + (renderBox.size.width ),
                                offset.dy + (renderBox.size.height),
                              ),
                              items: [
                                PopupMenuItem(
                                  value: "delete",
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text("Delete"),
                                    ],
                                  ),
                                ),
                              ],
                            );

                            if (result == "delete") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Message deleted")),
                              );
                            }
                          },
                          data: _message[index],
                          isMe: deviceId == _message[index].deviceID,
                        );
                      },
                      );
                    }
                ),
            ),
            // Expanded(
            //   child: FutureBuilder<Map<String,dynamic>?>(
            //       future: _PublicChatBackend.getAllPublicChat(page: '1'),
            //       builder: (context,snapshot){
            //         if(snapshot.connectionState == ConnectionState.waiting){
            //           return CustomCircularIndicator();
            //         }
            //         if(snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty){
            //
            //           return ListView.builder(
            //             shrinkWrap: true,
            //               itemCount: 2,
            //               itemBuilder: (context,index){
            //               return ChatMessageCard(
            //                 data: {
            //                   "id": 5,
            //                   "name": null,
            //                   "statement": "HII GAUAV",
            //                   "document": null,
            //                   "device_id": "fe819341-7338-4168-903a-5503379643ec",
            //                   "created_at": "22 Aug 2025",
            //                   "created_ago": "1 week ago"
            //                 },
            //                 isMe: index == 0,
            //               );
            //               }
            //           );
            //         }else{
            //          return const Padding(
            //            padding: EdgeInsets.all(16),
            //            child: Text("No messages yet..."), // Replace with ListView.builder later
            //          );
            //         }
            //       }
            //   ),
            // ),

            // Message input area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _statementController,
                        decoration: InputDecoration(
                          hintText: 'Type message...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.grey),
                    onPressed: () {
                      // TODO: Add file picker
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: ()async{
                      final statement = _statementController.text;
                      // try{
                      //   widget.channel.sink.add(statement);
                      // }catch(exception,trace){
                      //   print('Exception: $exception');
                      // }
                      final isSent = await _PublicChatBackend.sendMessage(statement: statement, deviceId: deviceId);
                      if(isSent){
                        _message.clear();
                        _fetchMessages();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    widget.channel.sink.close(1000,'NORMAL_CLOSER');
    super.dispose();
  }


}




class ChatMessageCard extends StatelessWidget {
  final ChatMessage data;
  final bool isMe;
  final VoidCallback? onLongPressed;

  const ChatMessageCard({Key? key, required this.data, this.isMe = false,this.onLongPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onLongPressed,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isMe ? Colors.teal : Colors.grey.shade200,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft:
              isMe ? const Radius.circular(16) : const Radius.circular(0),
              bottomRight:
              isMe ? const Radius.circular(0) : const Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // Sender Name if available
              if (data.name != null)
                Text(
                  data.name ?? "",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isMe ? Colors.white70 : Colors.black54,
                  ),
                ),

              // Message text
              Text(
                data.statement ?? "",
                style: TextStyle(
                  fontSize: 15,
                  color: isMe ? Colors.white : Colors.black87,
                ),
              ),

              const SizedBox(height: 6),


              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data.createdAt ?? "",
                    style: TextStyle(
                      fontSize: 11,
                      color: isMe ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  if (data.createdAgo != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      "(${data.createdAgo})",
                      style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: isMe ? Colors.white70 : Colors.black45,
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class _PublicChatBackend with ChangeNotifier{

  static Future<Map<String,dynamic>?> getAllPublicChat({required String page})async{
    try{
      final url = Uri.https(Urls.baseUrl,Urls.public_chat_list,{'page' : page});
      final response = await get(url,headers: {
        'content-type' : 'application/json',
        'Client-source' : 'mobile',
      });
      // print('Response Code: ${response.statusCode} Body: ${response.body} ');
      if(response.statusCode == 200){
        final body = json.decode(response.body);
        final status = body['success']??false;
        if(status){
          return body;
        }
      }
    }catch(exception,trace){
      print('Exception: $exception,Trace: $trace}');
    }
    return null;
}

static Future<bool> sendMessage({
    required String statement,
  required String deviceId,
  File? document,
})async {
    final position = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high,));
    final latitude = position.latitude;
    final longitude = position.longitude;
    try{
      final url = Uri.https(Urls.baseUrl,Urls.public_chat_entry);
      final request = http.MultipartRequest('POST' , url)
      ..headers.addAll({'Client-source' : 'mobile','Cotent-type' :'application/json'})
      ..fields['statement'] = statement
      ..fields['device_id'] = deviceId
      ..fields['app_name'] = 'mobile'
      ..fields['latitude'] = latitude.toStringAsFixed(6)
      ..fields['longitude'] = longitude.toStringAsFixed(6);

      if(prefs.getString(Consts.name) != null){
  request..fields['name'] = prefs.getString(Consts.name)!;
      }
      if(document != null){
        final mimeType = document.path.endsWith('.png')
                    ? MediaType('image', 'png')
                    : MediaType('image', 'jpeg');

                request.files.add(await http.MultipartFile.fromPath(
                  'document',
                  document.path,
                  contentType: mimeType,
                ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if(response.statusCode == 200 || response.statusCode == 201){
        print('Body: ${response.body}');
        return true;
      }
    }catch(exception,trace){
      print('Exception: ${exception} Trace: ${trace}');
    }
  return false;
}

static Future<bool> deleteMessage({required String messageId,required String deviceId})async{
    try{
      final uri = Uri.https(Urls.baseUrl,'/api/chat-discussion/${messageId}/public-delete/');
      final response = await post(uri,body: json.encode({
        'device_id' : deviceId
      }),headers: {
        'Content-type' : 'application/json',
        'Client-source' : 'mobile',
      });
      print('Response code: ${response.statusCode} , Body: ${response.body}');
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['success']??false;
        if(status){
          return true;
        }
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }
    return false;
}

}
