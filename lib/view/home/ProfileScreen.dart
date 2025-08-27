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
import 'package:survey_app/utilities/consts.dart';
import 'package:survey_app/utilities/cust_colors.dart';
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
  Widget build(BuildContext context) {
    return Consumer<AppUser>(
      builder: (context, user, child) {
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
                    "${userData["first_name"]} ${userData["last_name"]}";
                String joinedDate = DateFormat("dd MMM yyyy, hh:mm a")
                    .format(DateTime.parse(userData["joined_date"]));

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
                                user.isActive ? Iconsax.user_tag : Iconsax.user_remove,
                                color: Colors.white,
                              ),
                              label: Text(
                                user.isActive ? "Active" : "Inactive",
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor:
                              user.isActive ? Colors.green : Colors.redAccent,
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
                                  EditProfileScreen(userData: userData),
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
                                  userData["email"].toString().isEmpty
                                      ? "Not Provided"
                                      : userData["email"]),
                              _buildDetailTile(
                                  Iconsax.call, "Phone Number", userData["phone_number"]),
                              _buildDetailTile(Iconsax.calendar, "Joined Date", joinedDate),
                              _buildDetailTile(Iconsax.location, "Constituency",
                                  userData["constituency_name"].toString()),
                              _buildDetailTile(Iconsax.map, "State",
                                  userData["state"].toString()),
                              _buildDetailTile(Iconsax.buildings, "District",
                                  userData["district"].toString()),
                              _buildDetailTile(Iconsax.location_tick, "City",
                                  userData["city"].toString()),
                              _buildDetailTile(Iconsax.gps, "Pin Code",
                                  userData["pin_code"].toString()),
                              _buildDetailTile(Iconsax.home, "Address",
                                  userData["address"].toString()),
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
      },
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

  const EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _constituencyController= TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController() ;
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _selectedImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.userData["first_name"].toString();
    _lastNameController.text = widget.userData["last_name"].toString();
    _emailController.text = widget.userData["email"].toString();
    _constituencyController.text =  widget.userData["constituency_name"].toString();
    _stateController.text = widget.userData["state"].toString();
    _districtController.text =widget.userData["district"].toString();
    _cityController.text =widget.userData["city"].toString();
    _pinCodeController.text = widget.userData["pin_code"].toString();
    _addressController.text = widget.userData["address"].toString();
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
              _buildTextField("Constituency", _constituencyController,required: false),
              _buildTextField("State", _stateController,required: false),
              _buildTextField("District", _districtController,required: false),
              _buildTextField("City", _cityController,required: false),
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

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text, int maxLines = 1,bool required = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        validator: required ? (value){
          if(value == null || value.isEmpty || value == 'null'){
            return 'Please enter ${label}';
          }
          return null;
        }:null,
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.indigo)),
        ),
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
      "photo":  base64Profile,
      "constituency_name": _constituencyController.text,
      "state": _stateController.text,
      "district": _districtController.text,
      "city": _cityController.text,
      "pin_code": _pinCodeController.text,
      "address": _addressController.text,
      "app_name": "mobile",
    };

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

        Navigator.pop(context, true);
      } else {
        handleApiResponse(context, response);
      }
    } catch (e) {
      print("Update error: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }



}



