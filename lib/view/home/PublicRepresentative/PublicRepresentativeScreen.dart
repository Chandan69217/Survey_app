import 'package:flutter/material.dart';
import 'package:survey_app/api_service/PoliticianDetailsAPI.dart';
import 'package:survey_app/utilities/cust_colors.dart';
import 'package:survey_app/view/home/PublicRepresentative/PoliticianDetailsScreen.dart';
import 'package:survey_app/widgets/CustomCircularIndicator.dart';
import 'package:survey_app/widgets/custom_network_image.dart';

class PublicRepresentativeScreen extends StatefulWidget {
  PublicRepresentativeScreen({super.key});

  @override
  State<PublicRepresentativeScreen> createState() => _PublicRepresentativeScreenState();
}

class _PublicRepresentativeScreenState extends State<PublicRepresentativeScreen> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _politicianList = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasNext = true;
  bool _isFilterApplied = false;

  @override
  void initState() {
    super.initState();
    _fetchPoliticians();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasNext) {
        _fetchPoliticians();
      }
    });
  }

  Future<void> _fetchPoliticians() async {
    setState(() => _isLoading = true);

    try {
      final response = _isFilterApplied ? await PoliticianDetailsAPI(context: context).getPoliticianListByFilter(pageNo: _currentPage.toString())  :
      await PoliticianDetailsAPI(context: context)
          .getPoliticianList(pageNo: _currentPage.toString());
      if(response != null){
        final List<dynamic> newList = response['data'] ?? [];
        final paginationDetails = response['pagination'];
        final bool hasNext = paginationDetails['has_next'] ?? false;

        setState(() {
          _politicianList.addAll(newList);
          _hasNext = hasNext;
          _currentPage++;
        });
      }
    } catch (e) {
      debugPrint("Error fetching politicians: $e");
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustColors.background2,
      appBar: AppBar(
        title: Text(
          "Public Representative",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: CustColors.background1,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// FILTER SECTION BUTTON
              GestureDetector(
                onTap: () {
                  _showFilterBottomSheet(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CustColors.background1,
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
              ),
              const SizedBox(height: 20),

              /// REPRESENTATIVE CARDS
              Text(
                "Representative List",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _politicianList.isEmpty && !_isLoading
                    ? const Center(
                  child: Text(
                    'No Data Available',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                )
                    : ListView.builder(
                  controller: _scrollController,
                  itemCount: _politicianList.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _politicianList.length) {
                      return const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Center(child: CustomCircularIndicator()),
                      );
                    }

                    final rep = _politicianList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 2),
                      child: RepresentativeCard(
                        id: rep['id'].toString()??'',
                        name: rep["name"] ?? 'N/A',
                        party: rep["party_name"] ?? '',
                        role: rep["constituency_category"] ?? '',
                        desc: rep["about"] ?? '',
                        imageUrl: rep["party_logo"] ?? '',
                        avatarUrl: rep["photo"] ?? '',
                        rating: rep["rating"].toString(),
                        comments: rep["comment_count"].toString(),
                        performance: rep["performance"].toString(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDropdown("Constituency Type"),
              _buildDropdown("State"),
              _buildDropdown("Constituency"),
              _buildDropdown("District"),
              _buildDropdown("City"),
              _buildDropdown("Block"),
              _buildDropdown("Panchayat"),
              const SizedBox(height: 16),

              /// BUTTONS
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _isFilterApplied = true;
                        _politicianList = [];
                        _fetchPoliticians();
                        Navigator.pop(context); // close sheet
                      },
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
                      onPressed: () {
                        _isFilterApplied = false;
                        _politicianList = [];
                        _fetchPoliticians();
                        Navigator.pop(context); // close sheet
                      },
                      icon: const Icon(Icons.close, color: Colors.red),
                      label: const Text("Reset"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
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
              const SizedBox(height: 12),
            ],
          ),
        );
      },
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
  final  String id;
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
    required this.id,
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
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            isScrollControlled: true,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: Wrap(
                                  children: const [
                                    FeedbackForm(),
                                  ],
                                ),
                              );
                            },
                          );
                        },
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
                        onPressed: ()async {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PoliticianDetails(
                            id: id,
                          )));
                        },
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



