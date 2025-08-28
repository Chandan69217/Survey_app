import 'package:flutter/material.dart';
import 'package:survey_app/utilities/cust_colors.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: CustColors.background3
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Top Button "About Us"
              Container(
                decoration: BoxDecoration(
                  color: CustColors.navy_blue,
                  borderRadius: BorderRadius.circular(8)
                ),
                padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
                child: const Text(
                  "About Us",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Heading
              const Text(
                "Our Commitment to Transparency",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Description
              const Text(
                "We are a platform dedicated to empowering citizens to share their thoughts and feedback on Representative. Our mission is to foster transparency, accountability, and informed decision-making by providing a space where voices can be heard and opinions can shape the future of government.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),

              // Buttons Row
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildTagButton("Transparency", const Color(0xFF1ac7f7),
                      textColor: Colors.white),
                  _buildTagButton("Accountability", const Color(0xFF217a4a),
                      textColor: Colors.white),
                  _buildTagButton("Empowerment", const Color(0xFFf7bb00),
                      textColor: Colors.black),
                  _buildTagButton("Innovation", const Color(0xFF0a6fff),
                      textColor: Colors.white),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTagButton(String title, Color color, {Color textColor = Colors.white}) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(12),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
