import 'package:flutter/material.dart';
import 'package:survey_app/api_service/VerifyOTPService.dart';
import 'package:survey_app/utilities/custom_dialog/CustomMessageDialog.dart';
import 'package:survey_app/view/auth/CitizenSignUpScreen.dart';

class VerifyOTPScreen {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static String? verifiedOTP = null;
  static Future<void> show(BuildContext context,String number) {
    final List<TextEditingController> _otpControllers = List.generate(6, (index)=>TextEditingController());
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context,refresh){
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Floating cancel button
              Padding(
                padding: EdgeInsets.only(right: 12,bottom: 12,),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.redAccent,
                    child: Icon(Icons.close, color: Colors.white, size: 20),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: SafeArea(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 5,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Enter OTP",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "We have sent a 6-digit OTP to your number",
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 25),

                        // OTP Text Fields
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(6, (index) {
                            return SizedBox(
                              width: 50,
                              child: TextFormField(
                                controller: _otpControllers[index],
                                validator: (value){
                                  if(value == null || value.isEmpty){
                                    return '';
                                  }
                                  return null;
                                },
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  counterText: "",
                                  contentPadding: EdgeInsets.zero,
                                  filled: true,
                                  fillColor: const Color(0xfff2f3f7),
                                  // border: OutlineInputBorder(
                                  //   borderRadius: BorderRadius.circular(12),
                                  //   borderSide: BorderSide.none,
                                  // ),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty && index < 5) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                  if (value.isEmpty && index > 0) {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 30),

                        // Verify Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (){
                              _verifyOTP(context,number,_otpControllers);
                            },
                            child: const Text(
                              "Verify OTP",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  static void _verifyOTP(BuildContext context,String number,List<TextEditingController> otpControllers)async {

    if(!(_formKey.currentState?.validate()??false)){
      return;
    }
    var otp = '';
    for(var val in otpControllers){
      otp += val.text;
    }

    final data = await VerifyOTPService(context: context).verifyOTP(number, otp);
    if(data != null){
      final performed = data['performed']??false;
      final message = data['message']??'';
      CustomMessageDialog.show(
        context,
        title: "Success!",
        message: message,
        icon: Icons.check_circle,
        iconColor: Colors.greenAccent,
        buttonText: "Ok",
        onPressed: ()async{
          Navigator.of(context).pop();
          if(performed){
            verifiedOTP = otp;
            Navigator.of(context).pop();
            CitizenSignUpScreenState.isContactNumberVerified.value = performed;
          }
        }
      );

      // if(performed){
      //
      // }else{
      //   CustomMessageDialog.show(
      //     context,
      //     title: "Warring!",
      //     message: "The OTP you entered is incorrect.",
      //     icon: Icons.check_circle,
      //     iconColor: Colors.greenAccent,
      //     buttonText: "Continue",
      //   );
      // }
    }
    // Navigator.pop(context);
  }
}

