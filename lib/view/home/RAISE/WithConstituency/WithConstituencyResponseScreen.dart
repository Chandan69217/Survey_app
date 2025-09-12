import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:survey_app/api_service/PoliticianDetailsAPI.dart' show PoliticianDetailsAPI;
import 'package:survey_app/api_service/api_urls.dart';
import 'package:survey_app/main.dart';
import 'package:survey_app/utilities/consts.dart';
import 'package:survey_app/utilities/custom_dialog/CustomMessageDialog.dart';
import 'package:survey_app/utilities/custom_dialog/SnackBarHelper.dart';
import 'package:survey_app/utilities/location_permisson_handler/LocationPermissionHandler.dart';
import 'package:survey_app/view/home/PublicRepresentative/PoliticianDetailsScreen.dart';
import 'package:survey_app/widgets/BuildDropdown.dart';
import 'package:survey_app/widgets/CustomCircularIndicator.dart';
import 'package:survey_app/widgets/ImageViewer.dart';
import 'package:web_socket_channel/web_socket_channel.dart';



class WithConstituencyResponseScreen extends StatefulWidget {
  final String constituencyId;
  final String queryId;
  final int? initialRespoCount;
  final void Function(int totalResponse)? onResponseAdd;
  WithConstituencyResponseScreen({super.key,required this.constituencyId,required this.queryId,this.onResponseAdd,this.initialRespoCount = 0});
  @override
  State<WithConstituencyResponseScreen> createState() => _WithConstituencyResponseScreenState();
}

class _WithConstituencyResponseScreenState extends State<WithConstituencyResponseScreen> with SingleTickerProviderStateMixin{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final AnimationController _animationController;
  late final Animation<double> _extendedAnimation;
  late final WebSocketChannel _channel;
  List<dynamic> _responses = [];
  int _responseCount = 0;
  bool _isLoading = false;
  bool _showFeedbackForm = false;
  late final String deviceId;

  // widget.onResponseAdd?.call(++responseCount);


  @override
  void initState() {
   DeviceInfoPlugin().deviceInfo.then((value){
     final deviceInfo = value.data;
     deviceId = deviceInfo['id'];
   });
    WidgetsBinding.instance.addPostFrameCallback((duration)async{
      // _channel = WebSocketChannel.connect(Uri.parse('ws://truesurvey.in/ws/problems-solution/${widget.queryId}/'));
      // await _channel.ready;
      // _channel.stream.listen((value){
      //   if(value == null){
      //     return;
      //   }
      //   final jsonData = json.decode(value) as Map<String,dynamic>;
      //   print('Socket Received : $jsonData');
      //   if(mounted)
      //     setState(() {
      //       _responses.insert(0, jsonData['data']);
      //       widget.onResponseAdd?.call(++_responseCount);
      //     });
      //   // if(jsonData['event'].toLowercase() == 'created'){
      //   //
      //   // }
      // });
      _getResponse();
    });
    _responseCount = widget.initialRespoCount!;
    _animationController = AnimationController(vsync: this,duration: Duration(microseconds: 600));
    _extendedAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    super.initState();
  }

  @override
  void dispose() {
    // _channel.sink.close(1000,'Normal Close');
    super.dispose();
  }

  void _toggleForm() {
    setState(() {
      _showFeedbackForm = !_showFeedbackForm;
      if (_showFeedbackForm) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final details = _responses.isNotEmpty ? _responses.first['problem']??{} :{};
    return Scaffold(
      appBar: AppBar(title: Text('Issue Details and Responses',style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),),),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              // Issue details section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: "Issue Title : - ",
                                  style: const TextStyle(fontSize: 14),
                                  children: [
                                    TextSpan(
                                      text: details['title']??'N/A',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text.rich(
                                TextSpan(
                                  text: "Issue Details : - ",
                                  style: TextStyle(fontSize: 14),
                                  children: [
                                    TextSpan(
                                      text: details['problem']??'N/A',
                                      style: TextStyle(fontSize: 14),
                                    )
                                  ]
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: "Issue Date : - ",
                                style: TextStyle(fontSize: 14),
                                children: [
                                  TextSpan(
                                    text: details['created_at']??'N/A',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: "View Image : - ",
                                    style: TextStyle(fontSize: 14),
                                    children: [
                                      if(details['photo']==null)
                                      TextSpan(
                                        text: "No image",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if(details['photo'] != null)
                                TextButton(onPressed: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ImageViewerScreen(imageUrl: details['photo'])));
                                }, child: const Text('View'))
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Feedback button
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: _showFeedbackForm ? MainAxisSize.max:MainAxisSize.min,
                  children: [
                    if(_showFeedbackForm)
                    const Text("Submit Your Feedback",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue)),
                    ElevatedButton(
                      onPressed: _toggleForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        _showFeedbackForm ? "Close" :"Give Feedback",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              if(_showFeedbackForm)...[
                SizeTransition(
                  sizeFactor: _extendedAnimation,
                  axisAlignment: -1.0,
                  child: Column(
                    children: [
                      WithConstituencyFeedbackForm(
                        constituencyId: widget.constituencyId,
                        queryId: widget.queryId,
                        recentReview: _responses.firstWhere(
                              (v) => v['device_id'] == deviceId,
                          orElse: () => null,
                        ),
                      ),
                      const SizedBox(height: 16,),
                    ],
                  ),
                )
              ],

              // Responses header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "Responses :-",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade900,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Response card
              !_isLoading ? _responses.isNotEmpty ? ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: _responses.length,
                  shrinkWrap: true,
                  itemBuilder: (context,index){
                  final data = _responses[index];
                  final problem = data['problem']??{};

                    return Container(
                      padding: const EdgeInsets.all(12),
                      margin: EdgeInsets.only(bottom: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left side
                      Expanded(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['name']??'unknown',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          StarRating(
                            initialRating: data['rating']??0,
                            size: 18.0,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            data['comment']??'N/A',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                          const SizedBox(width: 4.0,),
                          // Right side
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: (data['solution_status']?['label']??'').toLowerCase() == 'resolved'?Colors.green.shade700:Colors.red.shade700,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  data['solution_status']?['label']??'',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                data['created_ago']??'',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
              ):Center(
                child: Text('No response'),
              ) : CustomCircularIndicator(),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getResponse()async{

    try{
      final accessToken = prefs.getString(Consts.accessToken)??'';
      final uri = Uri.https(
        Urls.baseUrl,'/api/soultion-query/${widget.queryId}/${widget.constituencyId}/public-create/list/'
      );


      setState(() {
        if(mounted){
          _isLoading = true;
        }
      });

      final response = await get(uri,headers: {
        'Authorization' : 'Bearer ${accessToken}',
        'Content-type' : 'application/json',
      });

      print('Response code: ${response.statusCode}, Body: ${response.body}');
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['success']??false;
        if(status){
          final data = body['data'];
          if(data != null){
            _responses.addAll(data);
          }
        }
      }
      
    }catch(exception,trace){
      print('Exception: ${exception}, Trace: ${trace}');
    }
    setState(() {
      if(mounted){
        _isLoading = false;
      }
    });
  }


}




class WithConstituencyFeedbackForm extends StatefulWidget {
  final String constituencyId;
  final String queryId;
  final Map<String,dynamic>? recentReview;

  const WithConstituencyFeedbackForm({super.key,required this.constituencyId,required this.queryId,this.recentReview});

  @override
  State<WithConstituencyFeedbackForm> createState() => _WithConstituencyFeedbackFormState();
}

class _WithConstituencyFeedbackFormState extends State<WithConstituencyFeedbackForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  int _rating = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? solutionStatus;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.recentReview != null ? widget.recentReview!['name']??'' : '';
    _rating = widget.recentReview != null ? widget.recentReview!['rating']??0:0;
    solutionStatus = widget.recentReview != null ? (widget.recentReview!['solution_status']?['key']):null;
    _messageController.text = widget.recentReview != null ? widget.recentReview!['comment']??'':'';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
            )
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Name
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Name (Optional)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),

            BuildDropdown('Solution status', [
              DropdownMenuItem<String>(child: Text('Resolved'),value: 'resolved',),
              DropdownMenuItem<String>(child: Text('Unresolved'),value: 'unresolved',),
            ],
              onChange: (value){
              if(mounted){
                setState(() {
                  solutionStatus = value;
                });
              }
              },
              value: solutionStatus
            ),
            /// Rating
            const Text("Rating",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4,),
            StarRating(
              initialRating: _rating,
              color: Colors.amber,
              size: 30,
              isReadOnly: false,
              onRatingChanged: (rating) {
                setState(() => _rating = rating);
              },
            ),
            const SizedBox(height: 12),

            /// Message
            TextFormField(
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Please enter comment';
                }
                if(value.length < 4){
                  return 'Comment should be between 3 and 150 characters';
                }
                return null;
              },
              controller: _messageController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Share your experience...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),

            /// Submit Button
            _isLoading ? CustomCircularIndicator():ElevatedButton.icon(
              onPressed: _onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                minimumSize: const Size(double.infinity, 48),
              ),
              icon: const Icon(Icons.send),
              label: const Text("Submit Feedback"),
            )
          ],
        ),
      ),
    );
  }



  void _onSubmit()async {
    if(solutionStatus == null){
      CustomMessageDialog.show(context,title: 'Solution Status',message: 'Please Select solution status');
      return;
    }
    if(_rating == 0){
      CustomMessageDialog.show(context,title: 'Rating Required',message: 'Please give your rating..');
      return;
    }
    if(!(_formKey.currentState?.validate()??false)){
      return;
    }

    final status = await getLocationPermission(context);
    if([].contains(status)){
      CustomMessageDialog.show(context, title: 'Allow Location', message: 'Please allow the location permission to submit your feedback');
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try{
      final accessToken = prefs.getString(Consts.accessToken)??'';
      final url = Uri.https(Urls.baseUrl,'/api/soultion-query/${widget.queryId}/${widget.constituencyId}/public-create/');
      final deviceInfo = await DeviceInfoPlugin().deviceInfo;
      final deviceId = deviceInfo.data['id'];
      final position = await Geolocator.getCurrentPosition();
      final latitude = double.parse(position.latitude.toStringAsFixed(6));
      final longitude = double.parse(position.longitude.toStringAsFixed(6));
      final headers = {
        'Authorization' : 'Bearer $accessToken',
        'Content-type' : 'application/json',
      };

      final body = {
        "name": _nameController.text,
        "comment":_messageController.text,
        "rating": _rating,
        "solution_status": solutionStatus,
        "latitude": latitude,
        "longitude": longitude,
        "device_id": deviceId,
        "app_name": "mobile"
      };

      final response = await post(url,body: json.encode(body),headers: headers);
      print('response code: ${response.statusCode}, Body: ${response.body}');
      if(response.statusCode == 200 || response.statusCode == 201){
        final data = json.decode(response.body) as Map<String,dynamic>;
        final message = data['message']??'';
        CustomMessageDialog.show(context, title: 'Successfully', message: message,icon: Icons.check_circle,iconColor: Colors.green);
      }else{
        SnackBarHelper.show(context, 'Something went wrong !');
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }

    setState(() {
      _isLoading = false;
    });

  }

}