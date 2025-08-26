import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PublicRepresentativeSlider extends StatelessWidget {
  final List<Map<String, String>> representatives;

  const PublicRepresentativeSlider({super.key, required this.representatives});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Public Representatives",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF001a44),
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to "View More" screen
                },
                child: const Text(
                  "View More",
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ],
          ),
        ),

        /// Slider
        CarouselSlider(
          options: CarouselOptions(
            height: 420,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            enableInfiniteScroll: true,
          ),
          items: representatives.map((rep) {
            return Builder(
              builder: (BuildContext context) {
                return _buildRepresentativeCard(
                  name: rep["name"]!,
                  party: rep["party"]!,
                  role: rep["role"]!,
                  desc: rep["desc"]!,
                  imageUrl: rep["imageUrl"]!,
                  avatarUrl: rep["avatarUrl"]!,
                  rating: rep["rating"]!,
                  comments: rep["comments"]!,
                  performance: rep["performance"]!,
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Card widget (from your code, just reused here)
  Widget _buildRepresentativeCard({
    required String name,
    required String party,
    required String role,
    required String desc,
    required String imageUrl,
    required String avatarUrl,
    required String rating,
    required String comments,
    required String performance,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(imageUrl,
                height: 200, width: double.infinity, fit: BoxFit.cover),
          ),
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
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(avatarUrl),
                        ),
                        const SizedBox(width: 6),
                        Text(name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF001a44),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(role,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(party,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                Text(desc,
                    style: const TextStyle(
                        fontSize: 13, color: Colors.black87)),
                const SizedBox(height: 12),

                /// Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStat("⭐", "Rating", rating, "from reviews",
                        Colors.blue),
                    _buildStat("💬", "Comments", comments, "public feedback",
                        Colors.green),
                    _buildStat("📊", "Performance", performance, "satisfaction",
                        Colors.orange),
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
                              borderRadius: BorderRadius.circular(8)),
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
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Details"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Small stat widget
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
