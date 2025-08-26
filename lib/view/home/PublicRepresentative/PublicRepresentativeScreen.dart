import 'package:flutter/material.dart';
import 'package:survey_app/utilities/cust_colors.dart';
import 'package:survey_app/widgets/custom_network_image.dart';

class PublicRepresentativeScreen extends StatelessWidget {
  const PublicRepresentativeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustColors.background2,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "PUBLIC REPRESENTATIVE",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// FILTER SECTION
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF001a44),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.filter_list, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Filter Representative",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 12),
        
              _buildDropdown("Constituency Type"),
              _buildDropdown("State"),
              _buildDropdown("Constituency"),
              _buildDropdown("District"),
              _buildDropdown("City"),
              _buildDropdown("Block"),
              _buildDropdown("Panchayat"),
        
              const SizedBox(height: 12),
        
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text("Apply"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF001a44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.close, color: Colors.red),
                      label: const Text("Reset"),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        
              const SizedBox(height: 20),
        
              /// REPRESENTATIVE CARDS
              RepresentativeCard(
                name: "John Doe",
                party: "raj • Bihar",
                role: "Assembly",
                desc: "An experienced leader focused on development.",
                imageUrl:
                "https://storage.googleapis.com/a1aa/image/fbca9ba6-ba61-4574-b8e0-42646aa9e451.jpg",
                avatarUrl:
                "https://storage.googleapis.com/a1aa/image/44501096-b486-44fd-977e-5684455eae16.jpg",
                rating: "5",
                comments: "2",
                performance: "51.1%",
              ),
              const SizedBox(height: 16),
        
              RepresentativeCard(
                name: "Tejaswi Yadav",
                party: "Rashtriya Janata Dal • Bihar",
                role: "Assembly",
                desc: "dfewdew",
                imageUrl:
                "https://storage.googleapis.com/a1aa/image/117a30e8-6c8a-46c7-b346-87eb7e004b4a.jpg",
                avatarUrl:
                "https://storage.googleapis.com/a1aa/image/eb2c5c4a-f792-4024-0dca-f5d3d71ff89b.jpg",
                rating: "0",
                comments: "0",
                performance: "0%",
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Dropdown Builder
  Widget _buildDropdown(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: null,
              isExpanded: true,
              underline: const SizedBox(),
              hint: Text("Select $label"),
              items: ["Option 1", "Option 2", "Option 3"]
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
                  .toList(),
              onChanged: (val) {},
            ),
          ),
        ],
      ),
    );
  }


}




class RepresentativeCard extends StatelessWidget {
  final String name;
  final String party;
  final String role;
  final String desc;
  final String imageUrl;
  final String avatarUrl;
  final String rating;
  final String comments;
  final String performance;

  const RepresentativeCard({
    super.key,
    required this.name,
    required this.party,
    required this.role,
    required this.desc,
    required this.imageUrl,
    required this.avatarUrl,
    required this.rating,
    required this.comments,
    required this.performance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          /// Cover Image
          CustomNetworkImage(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            imageUrl: imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            placeHolder: 'assets/images/Placeholder_image.webp',
          ),

          /// Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// NAME + ROLE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomNetworkImage(
                          width: 25,
                          height: 25,
                          borderRadius: BorderRadius.circular(20),
                          imageUrl: avatarUrl,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF001a44), // Navy Blue
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        role,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  party,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style:
                  const TextStyle(fontSize: 13, color: Colors.black87),
                ),
                const SizedBox(height: 12),

                /// Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStat("⭐", "Rating", rating, "from reviews",
                        Colors.blue),
                    _buildStat("💬", "Comments", comments, "public feedback",
                        Colors.green),
                    _buildStat("📊", "Performance", performance,
                        "satisfaction", Colors.orange),
                  ],
                ),
                const SizedBox(height: 12),

                /// Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Review"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Details"),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String icon, String title, String value, String subtitle,
      Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$icon $title",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        Text(value, style: const TextStyle(fontSize: 14)),
        Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }


}
