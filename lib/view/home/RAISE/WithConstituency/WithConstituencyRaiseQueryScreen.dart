import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/api_service/api_urls.dart';
import 'package:survey_app/api_service/handle_response.dart';
import 'package:survey_app/main.dart';
import 'package:survey_app/model/LoginUser.dart';
import 'package:survey_app/utilities/consts.dart';
import 'package:survey_app/utilities/cust_colors.dart';
import 'package:survey_app/utilities/custom_dialog/CustomMessageDialog.dart';
import 'package:survey_app/utilities/location_permisson_handler/LocationPermissionHandler.dart';
import 'package:survey_app/view/home/RAISE/WithoutConstituency/WithoutConstituencyQueryDetailsScreen.dart';
import 'package:survey_app/widgets/ChooseFile.dart';
import 'package:survey_app/widgets/CustomCircularIndicator.dart';
import 'package:survey_app/widgets/custom_network_image.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'WithConstituencyQueryDetailsScreen.dart';
import 'WithConstituencyResponseScreen.dart';



class WithConstituencyRaiseQueryScreen extends StatefulWidget {
  WithConstituencyRaiseQueryScreen({super.key,required this.constituencyId});
  final String constituencyId;
  @override
  State<WithConstituencyRaiseQueryScreen> createState() => _WithConstituencyRaiseQueryScreenState();
}

class _WithConstituencyRaiseQueryScreenState extends State<WithConstituencyRaiseQueryScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  List<dynamic> _queries = [];
  late Future<List<dynamic>> _savedTitle ;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // late final WebSocketChannel _channel;

  @override
  void initState(){
    _savedTitle = _getSavedTitle();
    WidgetsBinding.instance.addPostFrameCallback((duration)async{
      _fetchQueries();
      // try{
      //   _channel = WebSocketChannel.connect(Uri.parse('ws://truesurvey.in/ws/problems-constituency/3/'));
      //   await _channel.ready;
      // }catch(expetion){
      //   print('Exception: $expetion');
      // }
      // _channel.stream.listen((value){
      //   if(value == null){
      //     return;
      //   }
      //   final jsonData = json.decode(value) as Map<String,dynamic>;
      //   final data = jsonData['data'];
      //   if(mounted)
      //     setState(() {
      //       _queries.insert(0, data);
      //     });
      // });
    });
    // _scrollController.addListener((){
    //   if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading && _hasNext){
    //     _fetchQueries();
    //   }
    // });
    super.initState();
  }


  @override
  void dispose() {
    _scrollController.removeListener((){});
    // _channel.sink.close(1000,'Normal Close');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustColors.background3,
      appBar: AppBar(
        backgroundColor: CustColors.background1,
        title:  Consumer<LoginUser>(
          builder: (context,loginUser,child){
            return Text(
              loginUser.constituencyName!=null && loginUser.constituencyName?.name != null ? '${loginUser.constituencyName!.name} Query' :'Constituency Query',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
            );
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Label instead of button
                Row(
                  children: const [
                    Icon(Iconsax.category, size: 18, color: Colors.blue),
                    SizedBox(width: 6),
                    Text(
                      "Showing all queries",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                // Raise new button
                ElevatedButton.icon(
                  onPressed: () {
                    _showRaiseProblemDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                  icon: const Icon(Iconsax.add),
                  label: const Text("Raise New"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Query Card
            _queries.isNotEmpty ? Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: _queries.length,
                  itemBuilder: (context,index){
                    final query = _queries[index];
                    return GestureDetector(
                      onTap: ()async{
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> WithConstituencyQueryDetailsScreen(constituencyId: widget.constituencyId,id: query['id']?.toString()??'')));
                      },
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // photo + name
                            if(query['name'] != null)...[
                              Row(
                                children: [
                                  // CustomNetworkImage(
                                  //   height: 20,
                                  //   width: 20,
                                  //   imageUrl: query['photo'],
                                  // ),
                                  // const SizedBox(width: 8,),
                                  Text(query['name']??'Unknown',style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold),),
                                ],
                              ),
                              const SizedBox(height: 12,),
                            ],

                            // Title + Status
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if(query['photo'] != null)...[
                                  CustomNetworkImage(
                                    height: 60,
                                    width: 60,
                                    imageUrl: query['photo'],
                                  ),
                                  const SizedBox(width: 12.0,),
                                ],
                                Expanded(
                                  child: Text( query['title']??'N/A',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: ((query['problem_status']?['label'] ?? '').toLowerCase() == 'unresolved')
                                        ? Colors.yellow.shade100
                                        : Colors.green.shade100
                                    ,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    query['problem_status']?['label']??'',
                                    style: TextStyle(
                                      color: ((query['problem_status']?['label'] ?? '').toLowerCase() == 'unresolved')
                                          ? Colors.yellow.shade700
                                          : Colors.green.shade700
                                      ,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              query['problem']??'',
                              style: TextStyle(color: Colors.black87, height: 1.4),
                            ),
                            const SizedBox(height: 12),
                            // Time + Responses
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Iconsax.clock, size: 16, color: Colors.grey),
                                    SizedBox(width: 6),
                                    Text('${query['created_at']??''} (${query['created_ago']??''})', style: TextStyle(color: Colors.grey, fontSize: 13)),
                                  ],
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WithConstituencyResponseScreen(constituencyId: widget.constituencyId,initialRespoCount: int.parse(query['query_solutions']),queryId: query['id']?.toString()??'',onResponseAdd: (value){
                                      if(mounted){
                                        setState(() {
                                          query['query_solutions'] = value.toString();
                                        });
                                      }
                                    },)));
                                  },
                                  icon: const Icon(Iconsax.message, size: 16, color: Colors.blue),
                                  label: Text(
                                    "${query['query_solutions']??'0'} responses",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              ),
            ):_isLoading ? SizedBox.shrink():Expanded(child: Center(child: Text('No Queries Raised Yet.'))),
            if(_isLoading)...[
              Expanded(child: CustomCircularIndicator())
            ],
          ],
        ),
      ),
    );
  }

  void _fetchQueries()async{
    setState(() {
      _isLoading = true;
    });
    final response = await _getAllRaisedQuery();
    if(response == null){
      setState(() {
        _isLoading = false;
      });
      return;
    }
    setState(() {
      _isLoading = false;
      _queries = response['data'];
    });
  }


  Future<Map<String,dynamic>?> _getAllRaisedQuery()async{
    try{
      final accessToken = prefs.getString(Consts.accessToken)??'';
      final url = Uri.https(Urls.baseUrl,'/api/raise-query/${widget.constituencyId}/public-create/list/');
      final response = await get(url,headers: {
        'Authorization' : 'Bearer ${accessToken}',
        'Content-type' : 'application/json',
      },

      );
      print('Response Code: ${response.statusCode}, Body: ${response.body}');
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['success']??false;
        if(status){
          final data = body['data'] as List<dynamic>;
          if(data.isEmpty){
            return null;
          }
          return body;
        }
      }
    }catch(exception,trace){
      print('Exception: $exception , Trace: $trace');
    }
    return null;
  }

  void _showRaiseProblemDialog(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _problemController = TextEditingController();
    File? _selectedImage;
    bool _isLoading = false;
    String? _selectedSavedTitleQuery;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: StatefulBuilder(
            builder: (context,refresh){
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 24,
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Raise New Problem',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Title',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8.0,),
                          FutureBuilder<List<dynamic>>(
                              future: _savedTitle,
                              builder: (context,snapshot){
                                final data = snapshot.data;
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    border: Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButton<String>(
                                    borderRadius: BorderRadius.circular(12.0),
                                      underline: const SizedBox(),
                                      iconEnabledColor: Colors.white,
                                      style: TextStyle(color: Colors.white),
                                      dropdownColor: Colors.blue,
                                      elevation: 2,
                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                      value: _selectedSavedTitleQuery,
                                      items: [
                                        DropdownMenuItem<String>(child: Text('Select title'),value: null,),
                                        if(data != null && data.isNotEmpty)
                                          ...data.toSet().map<DropdownMenuItem<String>>(
                                              (e)=> DropdownMenuItem(child: Text(e.toString()),value: e.toString(),)
                                          ).toList()
                                      ],
                                      onChanged: (value){
                                        refresh((){
                                          _selectedSavedTitleQuery = value;
                                          _titleController.text = _selectedSavedTitleQuery??'';
                                        });
                                      }
                                  ),
                                );
                              }
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _titleController,
                        validator: (val){
                          if(val == null || val.isEmpty){
                            return 'Please enter query title';
                          }
                          return null;
                        },
                        maxLength: 30,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 20,),
                      const Text(
                        'Problem',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        validator: (val){
                          if(val == null || val.isEmpty){
                            return 'Please describe your problem';
                          }
                          return null;
                        },
                        controller: _problemController,
                        decoration: InputDecoration(
                          hintText: 'Describe your problem...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Attach File (Optional)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          ChooseFile.showImagePickerBottomSheet(context, (pickedFile){
                            refresh((){
                              _selectedImage = pickedFile;
                            });
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.attach_file, size: 20),
                              SizedBox(width: 8),
                              Text('Choose file'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _selectedImage != null ?_selectedImage!.path.split('/').last :'No file chosen',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 16),
                          _isLoading ? CustomCircularIndicator():ElevatedButton(
                            onPressed: ()async{
                              if(!(_formKey.currentState?.validate()??false)){
                                return;
                              }
                              refresh((){
                                _isLoading = true;
                              });
                              final title = _titleController.text;
                              final problem = _problemController.text;
                              final response = await _registerQuery(title: title, problem: problem,photo: _selectedImage);
                              if(response != null){
                                final message = response['message']??'';
                                CustomMessageDialog.show(context, title: 'Query Raised', message: message,);
                                _titleController.text = '';
                                _problemController.text = '';
                                _selectedImage = null;
                                _fetchQueries();
                              }
                              refresh((){
                                _isLoading = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    ).then((value){
      _selectedSavedTitleQuery = null;
    });
  }


  Future<List<dynamic>> _getSavedTitle()async{
    try{
      final url = Uri.https(Urls.baseUrl,Urls.query_save_title);
      final response = await get(url,headers: {
        'Content-type' : 'application/json',
        'Client-source' : 'mobile'
      });

      print('Response code: ${response.statusCode}, Body: ${response.body}');
      if(response.statusCode == 200){
       final body = json.decode(response.body) as Map<String,dynamic>;
       final status = body['success']??false;
       if(status){
         return body['data']??[];
       }
      }
    }catch(exception,trace){
      print('Exception: ${exception}, Trace: ${trace}');
    }
    return [];
  }


  Future<Map<String, dynamic>?> _registerQuery({
    required String title,
    required String problem,
    File? photo,
  }) async {
    final status = await getLocationPermission(context);

    if(status == LocationPermissionStatus.denied || status == LocationPermissionStatus.permanentlyDenied || status == LocationPermissionStatus.serviceDisabled){
      return null;
    }

    try{
      final accessToken = prefs.getString(Consts.accessToken)??"";
      final url = Uri.https(Urls.baseUrl,'/api/raise-query/${widget.constituencyId}/public-create/');
      final headers = {
        'Authorization' : 'Bearer ${accessToken}',
        'Content-Type': 'application/json',
      };

      final position =  await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high));
      final latitude = position.latitude.toStringAsFixed(6);
      final longitude = position.longitude.toStringAsFixed(6);
      final deviceInfo = await DeviceInfoPlugin().deviceInfo;
      final deviceId = await deviceInfo.data['id'];

      final Map<String,dynamic> value = {};

      value['title'] = title;
      value['name'] = prefs.getString(Consts.name);
      value['app_name'] = 'mobile';
      value['problem'] = problem;
      value['latitude'] = latitude;
      value['longitude'] = longitude;
      value['device_id'] = deviceId;

      String? base64String;

      if(photo != null){
        final extension = photo.path.split('.').last.toLowerCase();
        if (['png', 'jpg', 'jpeg'].contains(extension)) {
          final bytes = await photo.readAsBytes();
          final mediaType = extension == 'png' ? 'image/png' : 'image/jpeg';
          base64String = 'data:$mediaType;base64,${base64Encode(bytes)}';
        } else {
          print('Unsupported file type: $extension');
        }
      }

      value['photo'] = base64String;

      final body = json.encode(value);
      print('Body: $body');
      final response = await post(url,headers: headers,body: body);
      print('Response Code: ${response.statusCode} Response Body: ${response.body}');
      if(response.statusCode == 200 || response.statusCode == 201){
        final data = json.decode(response.body) as Map<String,dynamic>;
        final status  = data['success']??false;
        if(status)
        return data;
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }

    return null;
  }

}
