import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:survey_app/api_service/api_urls.dart';
import 'package:survey_app/main.dart';
import 'package:survey_app/utilities/consts.dart';
import 'package:survey_app/utilities/cust_colors.dart';
import 'package:survey_app/utilities/custom_dialog/CustomMessageDialog.dart';
import 'package:survey_app/utilities/custom_dialog/SnackBarHelper.dart';
import 'package:survey_app/widgets/CustomCircularIndicator.dart';


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        titleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '  Set a New Password',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Color(0xff0a6eff),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildPasswordField(
                    controller: _currentController,
                    hint: 'Enter current password',
                    label: 'Current Password *',
                    showPassword: _showCurrentPassword,
                    iconData:Icons.password_outlined,
                    toggleVisibility: () => setState(() =>
                    _showCurrentPassword = !_showCurrentPassword),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Current password is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    controller: _newController,
                    hint: 'Enter new password',
                    label: 'New Password *',
                    showPassword: _showNewPassword,
                    toggleVisibility: () =>
                        setState(() => _showNewPassword = !_showNewPassword),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'New password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    controller: _confirmController,
                    label: 'Confirm Password *',
                    hint: 'Enter confirm password',
                    showPassword: _showConfirmPassword,
                    toggleVisibility: () => setState(() =>
                    _showConfirmPassword = !_showConfirmPassword),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _newController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 34),
                  _isLoading ? CustomCircularIndicator():Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton(
                        label: 'Reset',
                        iconData: Icons.sync,
                        color: const Color(0xffef5a5a),
                        hoverColor: const Color(0xffd94a4a),
                        onPressed: () {
                          _formKey.currentState!.reset();
                          _currentController.clear();
                          _newController.clear();
                          _confirmController.clear();
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildButton(
                        label: 'Change',
                        iconData: Icons.check,
                        color: const Color(0xff0ac81f),
                        hoverColor: const Color(0xff0a9e1a),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            try{
                              final url = Uri.https(Urls.baseUrl,Urls.changePassword);
                              final accessToken = prefs.getString(Consts.accessToken)??'';
                              final body = json.encode({
                                "old_password": _currentController.text,
                                "new_password": _newController.text
                              });
                              final response = await post(url,body: body,headers: {
                                'Authorization' : 'Bearer $accessToken',
                                'content-type' : 'application/json'
                              });
                              print('Response code: ${response.statusCode} , Body: ${response.body}');
                              if(response.statusCode == 200){
                                final data = json.decode(response.body) as Map<String,dynamic>;
                                final status = data['success'];
                                if (status) {
                                  CustomMessageDialog.show(
                                      context,
                                      title: 'Password',
                                      message: data['messages'] ??'Password Changed Successfully'
                                  );
                                  _formKey.currentState!.reset();
                                  _currentController.clear();
                                  _newController.clear();
                                  _confirmController.clear();
                                } else {
                                  CustomMessageDialog.show(
                                      context,
                                      title: 'Password',
                                      message: data['messages'] ??
                                          'Password not changed');
                                }
                              }else{
                                SnackBarHelper.show(context, 'Something Sent wrong !!');
                              }
                            }catch(exception,trace){
                              print('Exception: ${exception}, Trace: ${trace}');
                            }

                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool showPassword,
    required VoidCallback toggleVisibility,
    String? label,
    IconData? iconData = Icons.lock,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !showPassword,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        prefixIcon: Icon(iconData,),
        suffixIcon: IconButton(
          icon: Icon(
            showPassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: toggleVisibility,
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff0a6eff), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildButton({
    required String label,
    required IconData iconData,
    required Color color,
    required Color hoverColor,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButton.icon(
        label: Text(label),
        icon: Icon(iconData),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(fontSize: 16),
        ).copyWith(
          overlayColor: MaterialStateProperty.all(hoverColor.withOpacity(0.8)),
        ),
        onPressed: onPressed,
      ),
    );
  }
}


