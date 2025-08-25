import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/api_service/VerifyOTPService.dart';
import 'package:survey_app/main.dart';
import 'package:survey_app/model/AppUser.dart';
import 'package:survey_app/utilities/consts.dart';
import 'package:survey_app/utilities/cust_colors.dart';
import 'package:survey_app/utilities/custom_dialog/CustomMessageDialog.dart';
import 'package:survey_app/view/auth/VerifyOTPScreen.dart';
import 'package:survey_app/widgets/CustomCircularIndicator.dart';

class CitizenSignUpScreen extends StatefulWidget {
  const CitizenSignUpScreen({super.key});

  @override
  State<CitizenSignUpScreen> createState() => CitizenSignUpScreenState();
}

class CitizenSignUpScreenState extends State<CitizenSignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _passwordVisibility = true;
  bool _confirmPasswordVisibility = true;
  static final ValueNotifier<bool> isContactNumberVerified = ValueNotifier<bool>(false);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration){
      isContactNumberVerified.value = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Citizen SignUp'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        titleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
      ),
      
      body: Container(
        decoration: BoxDecoration(
          gradient: CustColors.background_gradient
        ),
        child: Center(
          child: Container(
            width: 400,
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
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child:  Image.asset("assets/images/true_survey.jpg", scale: 4.1,width: 64,height: 64,),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: const Text(
                            "Sign Up with True Survey",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
              
                    // Name
                    const Text(
                      "Your Name",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Please Enter your name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter Your Name",
                      ),
                    ),
                    const SizedBox(height: 20),
              
                    // Contact
                    const Text(
                      "Contact No.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ValueListenableBuilder(valueListenable: isContactNumberVerified,
                        builder: (context,value,child){
                      return TextFormField(
                        readOnly: value,
                        validator: (value){
                          if(value == null || value.isEmpty ){
                            return 'Please your contact number';
                          }
                          if(value.length != 10){
                            return 'Please enter valid number';
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
                      );
                        }
                    ),
              
                    ValueListenableBuilder(valueListenable: isContactNumberVerified,
                        builder: (context,value,child){
                      if(value){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              "Password",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'Please enter password';
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
                            const SizedBox(height: 20),
                            const Text(
                              "Confirm Password",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _confirmPasswordController,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return 'Please enter Confirm password';
                                }
                                if(value != (_passwordController.text)){
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              obscureText: _confirmPasswordVisibility,
                              decoration: InputDecoration(
                                hintText: "Enter Confirm password",
                                suffixIcon: IconButton(onPressed: ()async{
                                  setState(() {
                                    _confirmPasswordVisibility = !_confirmPasswordVisibility;
                                  });
                                }, icon: Icon(_passwordVisibility ? Icons.visibility_off : Icons.visibility)),
              
                              ),
                            ),
                          ],
                        );
                      }else{
                        return SizedBox();
                      }
                        }
                    ),
              
                    const SizedBox(height: 28),
              
                    // Button
                    _isLoading ? CustomCircularIndicator() :ValueListenableBuilder<bool>(valueListenable: isContactNumberVerified,
                        builder: (context,value,child){
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: value ?_onPressedRegisterBtn :_onPressedSendOTPBtn,
                          child: Text(
                            value ? 'Register':"Send OTP",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                        }
                    ),
                    const SizedBox(height: 20),
              
                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Log in",
                            style: TextStyle(
                              fontSize: 14,
                              color: CustColors.soft_indigo100,
                              decoration: TextDecoration.underline
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
      ),
    );
  }


  Future<void> _onPressedSendOTPBtn()async{
    if(!(_formKey.currentState?.validate()??false)){
      return;
    };
    setState(() {
      _isLoading = true;
    });

    final data = await VerifyOTPService(context: context).sendOTPForRegister(_contactController.text);

    if(data != null && data['success']){
      final message = data['message'];
      final otp = data['data'];
      final performed = data['performed']??false;
      print('Sent OTP: $otp');
      if(performed){
        CustomMessageDialog.show(context, title: 'Success', message: message,onPressed: ()async{
          Navigator.of(context).pop();
          VerifyOTPScreen.show(context,_contactController.text);
        },buttonText: 'Continue');
      }else{
        CustomMessageDialog.show(context, title: 'Success', message: message,);
      }

    }
    setState(() {
      _isLoading = false;
    });

  }

  Future<void> _onPressedRegisterBtn()async{
    if(!(_formKey.currentState?.validate()??false)){
      return;
    };
    setState(() {
      _isLoading = true;
    });

    final data = await VerifyOTPService(context: context).register(
      name: _nameController.text,
      number: _contactController.text,
      otp: VerifyOTPScreen.verifiedOTP??'',
      password: _confirmPasswordController.text
    );

    if(data != null && data['success']){
      final message = data['message'];
      final performed = data['performed']??false;
      final status = data['success']??false;

      if(performed && status){
        final values = data['data'] as Map<String,dynamic>;
        final accessToken = values['access_token']??'';
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

        CustomMessageDialog.show(context,title: 'Success', message: message,onPressed: ()async{
          Navigator.of(context).popUntil((route)=> route.isFirst);
        },buttonText: 'Ok');
      }else{
        CustomMessageDialog.show(context, title: 'Success', message: message,);
      }

    }
    setState(() {
      _isLoading = false;
    });
  }

}
