import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/api_service/api_urls.dart';
import 'package:survey_app/api_service/handle_response.dart';
import 'package:survey_app/main.dart';
import 'package:survey_app/model/AppUser.dart';
import 'package:survey_app/model/LoginUser.dart';
import 'package:survey_app/providers/LocationFilterData.dart';
import 'package:survey_app/utilities/consts.dart';
import 'package:survey_app/utilities/cust_colors.dart';
import 'package:survey_app/utilities/custom_dialog/CustomMessageDialog.dart';
import 'package:survey_app/utilities/custom_dialog/SnackBarHelper.dart';
import 'package:survey_app/view/auth/ChangePasswordScreen.dart';
import 'package:survey_app/widgets/BuildDropdown.dart';
import 'package:survey_app/widgets/CustomCircularIndicator.dart';
import 'package:survey_app/widgets/custom_network_image.dart';



// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AppUser>(
//       builder: (context, user, child) {
//         return Scaffold(
//           backgroundColor: CustColors.background2,
//           appBar: AppBar(
//             title: Text("Profile",style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),),
//           ),
//           body: FutureBuilder<Map<String,dynamic>?>(
//               future: _getProfileDetailsFromAPI(),
//               builder: (context,snapshot){
//                 if(snapshot.connectionState == ConnectionState.waiting){
//                   return Center(
//                     child: CustomCircularIndicator(),
//                   );
//                 }
//
//                 if(snapshot.hasData && snapshot.data != null){
//                   final userData = snapshot.data!;
//                   String fullName = "${userData["first_name"]} ${userData["last_name"]}";
//                   String joinedDate = DateFormat("dd MMM yyyy, hh:mm a")
//                       .format(DateTime.parse(userData["joined_date"]));
//                   return ListView(
//                     shrinkWrap: true,
//                     padding: const EdgeInsets.all(12.0),
//                     children: [
//                       // // Profile Card
//                       Stack(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(20),
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(20),
//                                   gradient: CustColors.background_gradient,
//                                   boxShadow: [
//                                     BoxShadow(
//                                         blurRadius: 6,
//                                         offset: Offset(0, 4),
//                                         color: Colors.black.withValues(alpha: 0.1)
//                                     )
//                                   ]
//                               ),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   CustomNetworkImage(
//                                     imageUrl: user.photo,
//                                     placeHolder: 'assets/images/dummy_profile.webp',
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         const SizedBox(height: 6),
//                                         Text(
//                                           user.name ?? "Guest User",
//                                           style: const TextStyle(
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white
//                                           ),
//                                         ),
//                                         const SizedBox(height: 6),
//                                         Text(
//                                           user.isStaff ? "Staff Member" : "Regular User",
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             color: Colors.white54,
//                                           ),
//                                         ),]
//                                   )
//                                 ],
//                               ),
//                             ),
//                             Positioned(
//                                 right: 16,
//                                 top: 16,
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                       color: Colors.orange.shade400,
//                                       borderRadius: BorderRadius.circular(8.0)
//                                   ),
//                                   padding: EdgeInsets.symmetric(horizontal: 6.0,vertical: 2),
//                                   child: Text(user.isActive? 'Active':'In Active',style: TextStyle(color: Colors.white),),
//                                 )
//                             )
//                           ]
//                       ),
//
//
//                       // Profile Card
//                       Container(
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           color: Colors.indigo,
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.indigo.withOpacity(0.3),
//                               blurRadius: 10,
//                               offset: const Offset(0, 5),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             const CircleAvatar(
//                               radius: 50,
//                               backgroundImage: NetworkImage(
//                                 "https://i.pravatar.cc/300?img=5", // dummy profile pic
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             Text(
//                               fullName,
//                               style: const TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             Text(
//                               userData["role"] ?? "No Role Assigned",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.white.withOpacity(0.9),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//
//                       // Details Card
//                       Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         elevation: 5,
//                         child: Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: Column(
//                             children: [
//                               _buildDetailTile(Icons.email, "Email",
//                                   userData["email"].toString().isEmpty ? "Not Provided" : userData["email"]),
//                               _buildDetailTile(Icons.phone, "Phone Number",
//                                   userData["phone_number"]),
//                               _buildDetailTile(
//                                   Icons.calendar_today, "Joined Date", joinedDate),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 }else{
//                   return Center(
//                     child: Text('Something went wrong !!!'),
//                   );
//                 }
//               }
//           )
//         );
//       },
//     );
//   }
//
//   Widget _buildDetailTile(IconData icon, String title, String value) {
//     return Column(
//       children: [
//         ListTile(
//           leading: CircleAvatar(
//             backgroundColor: Colors.indigo.withOpacity(0.1),
//             child: Icon(icon, color: Colors.indigo),
//           ),
//           title: Text(title,
//               style: const TextStyle(fontWeight: FontWeight.bold)),
//           subtitle: Text(value,
//               style: const TextStyle(color: Colors.black87, fontSize: 15)),
//         ),
//         const Divider(),
//       ],
//     );
//   }
//
//   Future<Map<String,dynamic>?> _getProfileDetailsFromAPI()async{
//     final accessToken = prefs.getString(Consts.accessToken);
//     try{
//       final url = Uri.https(Urls.baseUrl,Urls.getProfileDetails);
//       final response = await get(url,headers: {
//         'Authorization' : 'Bearer $accessToken',
//         'content-type' :'Application/json'
//       });
//       print('Response code: ${response.statusCode},Body: ${response.body}');
//       if(response.statusCode == 200){
//         final data = json.decode(response.body) as Map<String,dynamic>;
//         final status = data['success']??false;
//         if(status){
//           final values = data['data'];
//           return values;
//         }
//       }else{
//         handleApiResponse(context, response);
//       }
//     }catch(exception,trace){
//       print('Exception: ${exception} Trace: ${trace}');
//     }
//     return null;
// }
// }


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustColors.background2,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white,),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _getProfileDetailsFromAPI(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CustomCircularIndicator());
          }

          if (snapshot.hasData && snapshot.data != null) {
            final userData = snapshot.data!;
            String fullName =
                "${userData["first_name"]??''} ${userData["last_name"]??''}";
            String joinedDate = userData['created_at'] != null ? DateFormat("dd MMM yyyy, hh:mm a")
                .format(DateTime.parse(userData["created_at"])):'N/A';
            final status = userData['status'] is Map && userData['status'] != null ? userData['status']: null;
            return SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [

                  Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            // gradient: CustColors.background_gradient,
                            gradient: LinearGradient(
                              colors: [Colors.pink.shade400, Colors.indigo.shade700],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.indigo.withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Hero(
                                tag: "profile-pic",
                                child: CustomNetworkImage(
                                  imageUrl: userData['photo']??'',
                                  width: 110,
                                  height: 110,
                                  borderRadius: BorderRadius.circular(60),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                fullName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                userData["role"] ?? "No Role Assigned",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 12,
                          child: Chip(
                            padding: EdgeInsets.symmetric(vertical: 4,horizontal: 2),
                            side: BorderSide(
                              style: BorderStyle.none,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(20)
                            ),
                            avatar: Icon(
                              status?['key']??false ? Iconsax.user_tag : Iconsax.user_remove,
                              color: Colors.white,
                            ),
                            label: Text( status?['label']??'',
                              // user.isActive ? "Active" : "Inactive",
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor:
                            status?['key']??false ? Colors.green : Colors.redAccent,
                          ),
                        ),
                      ]
                  ),
                  const SizedBox(height: 24),

                  // 🌟 Edit Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24),
                      elevation: 5,
                      shadowColor: Colors.indigo.shade300,
                    ),
                    icon: const Icon(Iconsax.edit, color: Colors.white),
                    label: const Text("Edit Profile",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EditProfileScreen(userData: userData,onUpdate: (){
                                setState(() {

                                });
                              },),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10,),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24),
                      elevation: 5,
                      shadowColor: Colors.blue.shade300,
                    ),
                    icon: const Icon(Iconsax.password_check, color: Colors.white),
                    label: const Text("Change Password",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20,),
                  // 🌟 Details Card
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0,bottom: 0),
                    child: Text('User Details',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 6,
                    shadowColor: Colors.indigo.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 8),
                      child: Column(
                        children: [
                          _buildDetailTile(Iconsax.sms, "Email",
                              userData["email"].toString().isEmpty || userData['email'] == null
                                  ? "Not Provided"
                                  : userData["email"]),
                          _buildDetailTile(
                              Iconsax.call, "Phone Number", userData["phone_number"]),
                          _buildDetailTile(Iconsax.calendar, "Joined Date", joinedDate),
                          _buildDetailTile(Iconsax.location, "Constituency",
                              userData["constituency_name"] is Map  && userData['constituency_name'] != null ? userData['constituency_name']['name']??'N/A'.toString():'N/A'),
                          _buildDetailTile(Iconsax.map, "State",
                              userData["state"] is Map && userData['state'] != null ? userData['state']['name']??'N/A'.toString():'N/A'),
                          _buildDetailTile(Iconsax.buildings, "District",
                              userData["district"] is Map && userData["district"] != null ? userData["district"]['name']??'N/A'.toString():'N/A'),
                          _buildDetailTile(Iconsax.location_tick, "City",
                              userData["city"] is Map && userData["city"] != null ? userData["city"]['name']??'N/A'.toString() : 'N/A'),
                          _buildDetailTile(Iconsax.gps, "Pin Code",
                              userData["pin_code"]??'N/A'.toString()),
                          _buildDetailTile(Iconsax.home, "Address",
                              userData["address"]??'N/A'.toString()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Something went wrong !!!'),
            );
          }
        },
      ),
    );
  }


  Widget _buildDetailTile(IconData icon, String title, String value) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.indigo.withOpacity(0.1),
            child: Icon(icon, color: Colors.indigo),
          ),
          title: Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(value,
              style: const TextStyle(color: Colors.black87, fontSize: 15)),
        ),
        const Divider(),
      ],
    );
  }

  Future<Map<String,dynamic>?> _getProfileDetailsFromAPI()async{
    final isLogin = prefs.getBool(Consts.isLogin)??false;
    if(!isLogin){
      return null;
    }
    final accessToken = prefs.getString(Consts.accessToken);
    try{
      final url = Uri.https(Urls.baseUrl,Urls.getProfileDetails);
      final response = await get(url,headers: {
        'Authorization' : 'Bearer $accessToken',
        'content-type' :'Application/json'
      });
      print('Response code: ${response.statusCode},Body: ${response.body}');
      if(response.statusCode == 200){
        final data = json.decode(response.body) as Map<String,dynamic>;
        final status = data['success']??false;
        if(status){
          final values = data['data'];
          prefs.setString(Consts.name, '${values['first_name'].toString()} ${values['last_name'].toString()}');
          prefs.setString(Consts.photo,values['photo']??'');
          context.read<AppUser>().update(
            photo: prefs.getString(Consts.photo),
            name: prefs.getString(Consts.name),
          );
          context.read<LoginUser>().update(values);
          return values;
        }
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: ${exception} Trace: ${trace}');
    }
    return null;
}


}



class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final VoidCallback? onUpdate;
  const EditProfileScreen({super.key, required this.userData,this.onUpdate});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _selectedImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration){
      initialized();
    });
  }

  Future<void> _pickImage() async {
    final picked =
    await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.userData;
    return Scaffold(

      appBar: AppBar(
        title: Text("Edit Profile",style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white,),),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true,
            children: [
              // Profile photo
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child:  Stack(
                      children: [
                        CustomNetworkImage(
                          imageUrl: data['photo'],
                          selectedFile: _selectedImage,
                          borderRadius: BorderRadius.circular(80),
                          width: 160,
                          height: 160,
                        ),
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: const Icon(Icons.edit, size: 18, color: Colors.indigo),
                          ),
                        ),
                      ]
                  ),
                ),
              ),
        
              const SizedBox(height: 20),
        
              _buildTextField("First Name", _firstNameController),
              _buildTextField("Last Name", _lastNameController),
              _buildTextField("Email", _emailController,required: false),
              Consumer<LocationFilterData>(
                builder: (context,value,child){
                  return Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      BuildDropdown('State',LocationFilterData.stateList.map<DropdownMenuItem<String>>(
                              (e) => DropdownMenuItem<String>(
                                  child: Text(e['name']??''.toString()),
                                value: e['id'].toString(),
                              )
                      ).toList(),
                          value: LocationFilterData.selectedState,
                        onChange: value.onStateChanged
                      ),
                      BuildDropdown('Constituency Category',
                          LocationFilterData.constituencyTypeList.map<DropdownMenuItem<String>>(
                                  (e) => DropdownMenuItem<String>(
                                child: Text(e['name']??''.toString()),
                                value: e['id'].toString(),
                              )
                          ).toList(),
                        value: LocationFilterData.selectedConstituencyType,
                        onChange: value.onConstituencyTypeChanged
                      ),
                      BuildDropdown('Constituency',
                          LocationFilterData.constituencyList.map<DropdownMenuItem<String>>(
                                  (e) => DropdownMenuItem<String>(
                                child: Text(e['name']??''.toString()),
                                value: e['id'].toString(),
                              )
                          ).toList(),
                        value: LocationFilterData.selectedConstituency,
                        onChange: value.onConstituencyChanged
                      ),
                      BuildDropdown('District',
                          LocationFilterData.districtList.map<DropdownMenuItem<String>>(
                                  (e) => DropdownMenuItem<String>(
                                child: Text(e['name']??''.toString()),
                                value: e['id'].toString(),
                              )
                          ).toList(),
                        value: LocationFilterData.selectedDistrict,
                        onChange: value.onDistrictChanged
                      ),
                      BuildDropdown('City',
                          LocationFilterData.cityList.map<DropdownMenuItem<String>>(
                                  (e) => DropdownMenuItem<String>(
                                child: Text(e['name']??''.toString()),
                                value: e['id'].toString(),
                              )
                          ).toList(),
                      value: LocationFilterData.selectedCity,
                        onChange: value.onCityChanged
                      ),
                    ],
                  );
                },
              ),
              _buildTextField("Pin Code", _pinCodeController,
                  keyboard: TextInputType.number,required: false),
              _buildTextField("Address", _addressController, maxLines: 4,required: false),
        
              const SizedBox(height: 20),
              _isLoading ? CustomCircularIndicator():ElevatedButton.icon(
                icon: const Icon(Icons.save, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                ),
                onPressed: () async {
                  await _updateProfile();
                },
                label: const Text("Save Changes",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        TextInputType keyboard = TextInputType.text,
        int maxLines = 1,
        bool required = true,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              controller: controller,
              keyboardType: keyboard,
              maxLines: maxLines,
              validator: required
                  ? (value) {
                if (value == null || value.isEmpty || value == 'null') {
                  return 'Please enter $label';
                }
                return null;
              }
                  : null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.transparent,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding:
                EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _updateProfile() async {
    if(!(_formKey.currentState?.validate()??false)){
      return;
    }

    setState(() {
      _isLoading = true;
    });
    final accessToken = prefs.getString(Consts.accessToken);

    String? base64Profile;
    if (_selectedImage != null) {
      final extension = _selectedImage!.path.split('.').last.toLowerCase();
      if(['png', 'jpg', 'jpeg'].contains(extension)){
        final bytes = await _selectedImage!.readAsBytes();
        final mediaType = extension == 'png' ? 'image/png' : 'image/jpeg';
        base64Profile = 'data:$mediaType;base64,${base64Encode(bytes)}';
      }else{
        print('Invalid Profile Picture');
      }
    }

    final body = {
      "first_name": _firstNameController.text,
      "last_name": _lastNameController.text,
      "email" : _emailController.text,
      "constituency_name": LocationFilterData.selectedConstituency??'',
      "state": LocationFilterData.selectedState??'',
      "district": LocationFilterData.selectedDistrict??'',
      "city": LocationFilterData.selectedCity??'',
      "pin_code": _pinCodeController.text,
      "address": _addressController.text,
      "app_name": "mobile",
    };
    if(base64Profile != null){
      body['photo'] = base64Profile;
    }

    print("Updated data: $body");

    final url = Uri.https(Urls.baseUrl, Urls.getProfileDetails);
    try {
      final response = await post(
        url,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );
      print('Response code: ${response.statusCode}, Body: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String,dynamic>;
        final message = data['message'];
        final status = data['success']??false;
        CustomMessageDialog.show(context, title: 'Profile Updated', message: message,onPressed: (){
          widget.onUpdate?.call();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      } else {
        SnackBarHelper.show(context, 'Something went wrong !!');
      }
    } catch (e) {
      print("Update error: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }


  @override
  void dispose() {
    super.dispose();
    LocationFilterData.selectedCity = null;
    LocationFilterData.selectedState = null;
    LocationFilterData.selectedConstituencyType = null;
    LocationFilterData.selectedConstituency = null;
    LocationFilterData.selectedDistrict = null;
  }

  void initialized()async {
    final provider = context.read<LocationFilterData>();
    final init = widget.userData;
    final state = init['state']??{};
    final district = init['district']??{};
    final constituency = init['constituency_name']??{};
    final constituencyCategory = constituency['category']??{};
    final city = init['city']??{};
    _firstNameController.text = init["first_name"]??''.toString();
    _lastNameController.text = init["last_name"]??''.toString();
    _emailController.text = init["email"]??''.toString();
    _pinCodeController.text = init["pin_code"]??''.toString();
    _addressController.text = init["address"]??''.toString();

    if(LocationFilterData.stateList.isNotEmpty && LocationFilterData.constituencyTypeList.isNotEmpty){
      LocationFilterData.selectedState = state['id'] != null ? state['id'].toString():null;
      LocationFilterData.selectedConstituencyType = constituencyCategory['id'] != null ?constituencyCategory['id'].toString() :null;
      provider.notify();
    }


    if(LocationFilterData.selectedState != null && LocationFilterData.selectedConstituencyType != null){
      await provider.getConstituencyList(constituencyTypeId: LocationFilterData.selectedConstituencyType!, stateId: LocationFilterData.selectedState!);
      if(LocationFilterData.constituencyList.isNotEmpty){
        LocationFilterData.selectedConstituency = constituency['id'] != null ? constituency['id'].toString():null;
        provider.notify();
      }
    }

    if(LocationFilterData.selectedState != null){
      await provider.getDistrictList(stateId: LocationFilterData.selectedState!);
      LocationFilterData.selectedDistrict = district['id'] != null ? district['id'].toString():null;
      provider.notify();
    }
    if(LocationFilterData.selectedDistrict != null){
      await provider.getCityList(districtId: LocationFilterData.selectedDistrict!);
      LocationFilterData.selectedCity = city['id'] != null ?city['id'].toString() :null;
      provider.notify();
    }

  }


}



