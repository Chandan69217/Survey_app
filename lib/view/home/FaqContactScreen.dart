import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/api_service/api_urls.dart';
import 'package:survey_app/utilities/cust_colors.dart';
import 'package:survey_app/utilities/custom_dialog/CustomMessageDialog.dart';
import 'package:survey_app/widgets/CustomCircularIndicator.dart';
import 'package:url_launcher/url_launcher.dart';


class FaqContactScreen extends StatefulWidget {
  final Key? contactUsKey;
  FaqContactScreen({super.key,this.contactUsKey});

  @override
  State<FaqContactScreen> createState() => FaqContactScreenState();
}

class FaqContactScreenState extends State<FaqContactScreen> {
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _subjectController = TextEditingController();

  final TextEditingController _messageController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _subjectFocusNode = FocusNode();
  final FocusNode _messageFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // FAQ Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Frequently Asked Questions",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff0f1f40),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Welcome to our FAQ section. Here you’ll find answers to common questions regarding how this platform works and how your feedback is handled securely.",
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xff0f1f40),
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  "https://storage.googleapis.com/a1aa/image/e0d53c91-8aa3-47f3-8fcb-e4a4c66f152e.jpg",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              ...faqList.map(
                    (item) => FaqItem(
                  question: item["q"]!,
                  answer: item["a"]!,
                ),
              ),
            ],
          ),
        ),

        // Contact Section
        Container(
          key: widget.contactUsKey,
          width: double.infinity,
          color: CustColors.background3,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "CONTACT",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "GET INTO TOUCH",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: CustColors.navy_blue,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                height: 2,
                width: 60,
                color: Color(0xff7dd3fc),
              ),
              const SizedBox(height: 16),

              // Contact Cards
              Column(
                children: [
                  const ContactCard(
                    icon: Icons.location_on,
                    title: "Address",
                    subtitle: "Boring Road, Patna",
                    iconBg: Color(0xffccfbf1),
                    iconColor: Color(0xff2dd4bf),
                  ),
                  const SizedBox(height: 12),
                  ContactCard(
                    icon: Icons.phone,
                    title: "Call Us",
                    subtitle: "+91 7667833826",
                    iconBg: const Color(0xfffef3c7),
                    iconColor: const Color(0xfffbbf24),
                    onTap: ()async{
                      final Uri uri = Uri(scheme: 'tel', path: '+91 7667833826');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      } else {
                        throw 'Could not launch +91 7667833826';
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  ContactCard(
                    onTap: ()async{
                      final Uri uri = Uri(scheme: 'mailto',path: 'truesurvey18@gmail.com');
                      if(await canLaunchUrl(uri)){
                        await launchUrl(uri);
                      }else{
                        throw 'Could not launch email client';
                      }
                    },
                    icon: Icons.email,
                    title: "Email Us",
                    subtitle: "truesurvey18@gmail.com",
                    iconBg: Color(0xffd1fae5),
                    iconColor: Color(0xff34d399),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Contact Form
              ValueListenableBuilder(
                valueListenable: _isLoading,
                builder: (context,value,child){
                  return Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                    hint: "Your Name",
                                  controller: _nameController,
                                  focusNode: _nameFocusNode,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                    hint: "Your Email",
                                  controller: _emailController,
                                  focusNode: _emailFocusNode,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                              hint: "Subject",
                            controller: _subjectController,
                            focusNode: _subjectFocusNode,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            hint: "Message",
                            controller: _messageController,
                            focusNode: _messageFocusNode,
                            maxLines: 5,
                          ),
                          const SizedBox(height: 20),
                          value ? CustomCircularIndicator(): ElevatedButton(
                            onPressed: _sendMessage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff34d399),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                            ),
                            child: const Text(
                              "Send Message",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }



  void unFocus() {
    _nameFocusNode.unfocus();
    _emailFocusNode.unfocus();
    _subjectFocusNode.unfocus();
    _messageFocusNode.unfocus();
  }


  void _sendMessage()async {
    if(!(_formKey.currentState?.validate()??false)){
      return;
    }
    _isLoading.value = true;
    final String name = _nameController.text??'';
    final String email = _emailController.text??'';
    final String subject = _subjectController.text??'';
    final String message = _messageController.text??'';

    try{
      final uri = Uri.https(Urls.baseUrl,Urls.contact_us);
      final body = {
        "name": name,
        "email": email,
        "subject": subject,
        "message": message,
      };

      final response = await post(uri,body: json.encode(body),headers: {
        'Content-Type': 'application/json'
      });

      print('Response Code: ${response.statusCode}, Body: ${response.body}');
      if(response.statusCode == 201 || response.statusCode == 200){
        final data = json.decode(response.body) as Map<String,dynamic>;
        final message = data['message']??'';
        CustomMessageDialog.show(context, title: 'Success', message: message,iconColor: Colors.green,icon: Icons.check_circle_rounded,buttonText: 'Ok');
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }
    _isLoading.value = false;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _nameFocusNode.dispose();
    _emailController.dispose();
    _emailFocusNode.dispose();
    _subjectController.dispose();
    _subjectFocusNode.dispose();
    _messageController.dispose();
    _messageFocusNode.dispose();
  }
}

// FAQ Data with answers
final List<Map<String, String>> faqList = [
  {
    "q": "What is this platform about?",
    "a": "This platform collects anonymous feedback to improve transparency and decision-making."
  },
  {
    "q": "Do I need to register to give feedback?",
    "a": "No registration is required. You can submit feedback directly."
  },
  {
    "q": "How is my feedback kept anonymous?",
    "a": "We don’t store your personal information with your feedback."
  },
  {
    "q": "Can I edit or delete my submitted feedback?",
    "a": "Once submitted, feedback cannot be edited or deleted to preserve data integrity."
  },
  {
    "q": "Who can see the feedback?",
    "a": "Only authorized reviewers can access feedback."
  },
  {
    "q": "Is my feedback reviewed in real-time?",
    "a": "Feedback is reviewed periodically, not instantly."
  },
  {
    "q": "How can I be sure my data is not misused?",
    "a": "We follow strict privacy policies and do not share data with third parties."
  },
  {
    "q": "Can feedback influence policy or actions?",
    "a": "Yes, feedback helps identify issues and improve policies."
  },
  {
    "q": "Is this platform officially affiliated with the government?",
    "a": "No, this platform is independent and community-driven."
  },
];

/// FAQ Tile with Expansion
class FaqItem extends StatelessWidget {
  final String question;
  final String answer;
  const FaqItem({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xfff5a623)),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xfff5a623)),
        ),
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        title: Text(
          question,
          style: const TextStyle(fontSize: 13, color: Color(0xff0f1f40)),
        ),
        trailing: const Icon(Icons.keyboard_arrow_down, size: 20),
        children: [
          Text(
            answer,
            style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.4),
          )
        ],
      ),
    );
  }

}

class ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback? onTap;

  const ContactCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconBg,
    required this.iconColor,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3))
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: iconBg,
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff0f1f40))),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff6b7280),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hint;
  final int maxLines;
  final TextEditingController controller;
  final bool isRequired;
  final FocusNode? focusNode;
  const CustomTextField({super.key,this.focusNode ,required this.hint, this.maxLines = 1,required this.controller,this.isRequired = true});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      autofocus: false,
      focusNode: focusNode,
      controller: controller,
      validator: (value){
        if(value == null || value.isEmpty){
          return 'Please enter ${hint}';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff34d399), width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

