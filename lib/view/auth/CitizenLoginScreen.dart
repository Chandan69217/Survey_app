import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/api_service/api_urls.dart';
import 'package:survey_app/api_service/handle_response.dart';
import 'package:survey_app/main.dart';
import 'package:survey_app/model/AppUser.dart';
import 'package:survey_app/utilities/consts.dart';
import 'package:survey_app/utilities/cust_colors.dart';
import 'package:survey_app/utilities/custom_dialog/SnackBarHelper.dart';
import 'package:survey_app/view/auth/CitizenSignUpScreen.dart';
import 'package:survey_app/view/auth/ForgotPasswordScreen.dart';
import 'package:survey_app/widgets/CustomCircularIndicator.dart';

class CitizenLoginScreen extends StatefulWidget {
  const CitizenLoginScreen({super.key});

  @override
  State<CitizenLoginScreen> createState() => _CitizenLoginScreenState();
}

class _CitizenLoginScreenState extends State<CitizenLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisibility = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: CustColors.background2,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Citizen Login'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        titleTextStyle:  Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: CustColors.background_gradient
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.people, color: CustColors.soft_indigo),
                        const SizedBox(width: 8),
                        Text(
                          "Citizen Login",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: CustColors.soft_indigo),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Logo + Title
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child:  Image.asset("assets/images/true_survey.jpg", scale: 4.1,width: 64,height: 64,),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            "Log in with True Survey",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Contact Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Contact No.",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _contactNoController,
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Please enter contact no.';
                            }
                            if(value.length != 10){
                              return 'Please enter valid contact no.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: "Enter Contact No.",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Password Field + Forgot
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Password",
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ForgotPasswordScreen()));
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(color: CustColors.soft_indigo),
                              ),
                            )
                          ],
                        ),
                        TextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          obscureText: _passwordVisibility,
                          decoration: InputDecoration(
                            hintText: "Enter your password",
                            suffixIcon: IconButton(onPressed: ()async{
                              setState(() {
                                _passwordVisibility = !_passwordVisibility;
                              });
                            }, icon: Icon(_passwordVisibility ? Icons.visibility_off : Icons.visibility)),

                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height:16),

                    // Login Button
                    _isLoading ?CustomCircularIndicator() :SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustColors.soft_indigo,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _onLogin,
                        child: const Text(
                          "LOG IN",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Footer Links
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CitizenSignUpScreen()));
                              },
                              child: const Text(
                                "Sign up",
                                style: TextStyle(color: CustColors.soft_indigo100,decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        ),
                        // const SizedBox(height: 12),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     const Text("Staff or Admin ? "),
                        //     GestureDetector(
                        //       onTap: () {},
                        //       child: const Text(
                        //         "Admin Login",
                        //         style: TextStyle(color: CustColors.soft_indigo100,decoration: TextDecoration.underline),
                        //       ),
                        //     )
                        //   ],
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onLogin() async{
    if(!(_formKey.currentState?.validate()??false)){
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try{
      final url = Uri.https(Urls.baseUrl,Urls.login);
      final body = json.encode({
        "phone_number": _contactNoController.text??'',
        "password": _passwordController.text??'',
        "app_name": "mobile"
      });

      final response = await post(url,body: body,headers: {
        'content-type' : 'Application/json'
      });

      print('Response code: ${response.statusCode}, Response Body: ${response.body}');
      if(response.statusCode == 200){
        final data = json.decode(response.body) as Map<String,dynamic>;
        final status = data['success']??false;
        if(status){
          final message = data['message']??'';
          final performed = data['performed']??false;
          final accessToken = data['access_token']??'';
          final values = data['data'] as Map<String,dynamic>;
          final name = values['name']??'N/A';
          final is_staff = values['is_staff']??false;
          final is_active = values['is_active']??false;
          final photo = values['photo']??'';

          prefs.setBool(Consts.performed,performed);
          prefs.setString(Consts.accessToken,accessToken);
          prefs.setString(Consts.name, name);
          prefs.setBool(Consts.isStaff, is_staff);
          prefs.setBool(Consts.isActive, is_active);
          prefs.setString(Consts.photo, photo);
          prefs.setBool(Consts.isLogin, true);

          Provider.of<AppUser>(context, listen: false).update(
            name: name,
            isActive: is_active,
            accessToken: accessToken,
            isOnBoarded: true,
            isStaff: is_staff,
            performed: performed,
            photo: photo,
            isLogin: true,
          );

          SnackBarHelper.show(context, message);

          Navigator.of(context).popUntil((route)=>route.isFirst);
        }else{
          final message = data['message']??'';
          SnackBarHelper.show(context, message);
        }
      } else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }
    setState(() {
      _isLoading = false;
    });

  }
}
