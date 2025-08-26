import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:survey_app/api_service/VerifyOTPService.dart';
import 'package:survey_app/api_service/api_urls.dart';
import 'package:survey_app/api_service/handle_response.dart';
import 'package:survey_app/utilities/cust_colors.dart';
import 'package:survey_app/utilities/custom_dialog/CustomMessageDialog.dart';
import 'package:survey_app/view/auth/CitizenSignUpScreen.dart';
import 'package:survey_app/view/auth/VerifyOTPScreen.dart';
import 'package:survey_app/widgets/CustomCircularIndicator.dart';

class ForgotPasswordScreen extends StatefulWidget {

  ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _contactController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisibility = true;
  bool _confirmPasswordVisibility = true;
  final TextEditingController _confirmPasswordController = TextEditingController();
  final ValueNotifier<bool> _isContactNumberVerified = ValueNotifier<bool>(false);
  bool _isLoading = false;
  String? _verifiedOTP ;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Forgot Password'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        titleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Colors.white,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: CustColors.background_gradient
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child:  Image.asset("assets/images/true_survey.jpg", scale: 4.1,width: 64,height: 64,),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Reset Password",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder<bool>(
                      valueListenable: _isContactNumberVerified,
                      builder: (context,value,child){
                        if(!value){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Contact No.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                validator: (value){
                                  if(value == null || value.isEmpty){
                                    return 'Please enter contact no';
                                  }
                                  if(value.length != 10){
                                    return 'Please enter valid contact no';
                                  }
                                  return null;
                                },
                                controller: _contactController,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                decoration: InputDecoration(
                                    hintText: "Enter Contact No.",
                                    counterText: ''
                                ),
                              ),
                            ],
                          );
                        }else{
                          return SizedBox();
                        }
                      }
                  ),
                  ValueListenableBuilder<bool>(
                      valueListenable: _isContactNumberVerified,
                      builder: (context,value,child){
                        if(value){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Password",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                validator: (value){
                                  if(value == null || value.isEmpty){
                                    return 'Please new password';
                                  }
                                  return null;
                                },
                                controller: _passwordController,
                                obscureText: _passwordVisibility,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                    hintText: "Enter new password",
                                    counterText: '',
                                  suffixIcon: IconButton(onPressed: ()async{
                                    setState(() {
                                      _passwordVisibility = !_passwordVisibility;
                                    });
                                  }, icon: Icon(_passwordVisibility ? Icons.visibility_off:Icons.visibility))
                                ),
                              ),

                              const SizedBox(height: 20,),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Confirm Password",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                validator: (value){
                                  if(_passwordController.text.isNotEmpty && (value == null || value.isEmpty)){
                                    return 'Please enter confirm password';
                                  }
                                  if(_passwordController.text != value){
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                                controller: _confirmPasswordController,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: _confirmPasswordVisibility,
                                decoration: InputDecoration(
                                    hintText: "Enter confirm password",
                                    counterText: '',
                                    suffixIcon: IconButton(onPressed: ()async{
                                      setState(() {
                                        _confirmPasswordVisibility = !_confirmPasswordVisibility;
                                      });
                                    }, icon: Icon(_confirmPasswordVisibility ? Icons.visibility_off:Icons.visibility))
                                ),
                              ),
                            ],
                          );
                        }else{
                          return SizedBox();
                        }
                      }
                  ),
                  const SizedBox(height: 20),
                  _isLoading ? CustomCircularIndicator() :
                  ValueListenableBuilder<bool>(valueListenable: _isContactNumberVerified,
                      builder: (context,value,child){
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(

                        onPressed: value ? _changePassword :_sendOTP,
                        child: Text(
                         value ? "Change Password": "Send OTP",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                      }
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> CitizenSignUpScreen()));
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            color: CustColors.soft_indigo,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendOTP() async{
    if(!(_formKey.currentState?.validate()??false)){
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final contact_no = _contactController.text;
    final data = await VerifyOTPService(context: context).sendOTPForReset(contact_no);

    if(data != null){
      final message = data['message']??'';
      final bool performed = data['performed']??false;
      final bool status = data['success']??false;
      if(status){
        CustomMessageDialog.show(
          context, title: 'Success', message: message,icon: Icons.check_circle_rounded,iconColor: Colors.green,buttonText: 'Continue',
          onPressed: ()async{
            Navigator.of(context).pop();
            if(performed){
              VerifyOTPScreen.show(context, contact_no,onVerified:(isVerified,otp){
                _isContactNumberVerified.value = isVerified;
                _verifiedOTP = otp;
              });
            }
          }
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _changePassword() async {
    if(!(_formKey.currentState?.validate()??false)){
      return null;
    }
    setState(() {
      _isLoading = true;
    });

    try{
      final url = Uri.https(Urls.baseUrl,Urls.resetPassword);
      final phone_number = _contactController.text??'';
      final password = _confirmPasswordController.text??'';
      final body = json.encode({
        "phone_number": phone_number,
        "otp": _verifiedOTP??'',
        "password": password
      });

      final response  = await post(url,body: body,headers: {
        'content-type' : 'Application/json'
      });

      print('Response Code: ${response.statusCode},Body: ${response.body}');

      if(response.statusCode == 200){
        final data = json.decode(response.body) as Map<String,dynamic>;
        final status = data['success']??false;
        final performed = data['performed']??false;
        final message = data['message']??'';
        if(status){
          CustomMessageDialog.show(context, title: 'Success', message: message,
            icon: Icons.check_circle_rounded,
            iconColor: Colors.green,
            buttonText: 'Continue',
            onPressed: ()async{
              if(performed){
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }else{
                Navigator.of(context).pop();
              }
            }
          );
        }
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace:${trace}');
    }

    setState(() {
      _isLoading = false;
    });
  }

}
