import 'package:flutter/material.dart';
import 'package:survey_app/api_service/PoliticianDetailsAPI.dart';
import 'package:survey_app/utilities/cust_colors.dart';
import 'package:survey_app/utilities/custom_dialog/CustomMessageDialog.dart';
import 'package:survey_app/utilities/custom_dialog/SnackBarHelper.dart';
import 'package:survey_app/widgets/CustomCircularIndicator.dart';
import 'package:survey_app/widgets/custom_network_image.dart';

class PoliticianDetails extends StatefulWidget {
  final String id;
  const PoliticianDetails({super.key,required this.id});

  @override
  State<PoliticianDetails> createState() => _PoliticianDetailsState();
}

class _PoliticianDetailsState extends State<PoliticianDetails> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustColors.background2,
      appBar: AppBar(
        title: Text("Details",style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),),
        backgroundColor: CustColors.background1,
      ),
      body: FutureBuilder(future: PoliticianDetailsAPI(context: context).getPoliticianDetails(id: widget.id), 
          builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return CustomCircularIndicator();
        }
        if(snapshot.hasData && snapshot.data != null){
          final politicianDetails = snapshot.data!['politician_details']??{};
          final List<dynamic> strength = politicianDetails['strength']??[];
          final List<dynamic> improvement = politicianDetails['improvement']??[];
          final feedbacks = snapshot.data!['feedbacks']??[];
          final List<dynamic> reviews =
          (feedbacks is Map && feedbacks['data'] is List)
              ? feedbacks['data'] as List<dynamic>
              : [];
          final List<dynamic> conclude_message = snapshot.data!['conclude_messages']??[];
          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            child: SafeArea(
              child: Column(
                children: [
                  /// Profile Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                        )
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        CustomNetworkImage(
                          width: 120,
                          height: 120,
                          borderRadius: BorderRadius.circular(80),
                          imageUrl: politicianDetails['photo']??'',
                        ),
                        const SizedBox(height: 4),
                        Text(
                          politicianDetails['name']??'N/A',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "${politicianDetails['constituency_category']??''}, ${politicianDetails['constituency']??''} (${politicianDetails['state']??''})",
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomNetworkImage(
                              width: 22,
                              height: 22,
                              imageUrl: politicianDetails['party_logo']??'',
                              borderRadius: BorderRadius.circular(20),
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              politicianDetails['party_name']??'N/A',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const Divider(height: 28),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber),
                                      const SizedBox(width: 4,),
                                      Text("${politicianDetails['rating'].toInt()??'0'} / 5",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.amber)),
                                    ],
                                  ),
                                  const Text("People's\nRating",
                                    style: TextStyle(fontSize: 11,),textAlign: TextAlign.center,),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(politicianDetails['comment_count']??'0',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  Text("Community\nInteractions",
                                    style: TextStyle(fontSize: 11,),textAlign: TextAlign.center,),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        child: LinearProgressIndicator(
                                          color: Colors.blue,
                                          value: _getValueFromPercentage(politicianDetails['performance'].toDouble()??0.0),
                                          borderRadius: BorderRadius.circular(20),
                                          minHeight: 6,
                                        ),
                                      ),
                                      const SizedBox(width: 4,),
                                      Text("${politicianDetails['performance']??0.0}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  const Text("Overall\nPerformance",
                                    style: TextStyle(fontSize: 10,),textAlign: TextAlign.center,),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// Performance Rating
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                        )
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Performance Rating",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue)),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text("${politicianDetails['rating'].toInt().toString()}/5",
                                  style: TextStyle(color: Colors.white)),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        StarRating(
                          initialRating: politicianDetails['rating'],
                          color: Colors.amber,
                          size: 30,
                          isReadOnly: true,
                        ),
                        const SizedBox(height: 6),
                        Text("Based on ${politicianDetails['comment_count'].toString()} public reviews",
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// Submit Feedback
                  FeedbackForm(politicianId: widget.id,onSubmit: (){
                    setState(() {

                    });
                  },),
                  const SizedBox(height: 12),

                  /// About
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                        )
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("About",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.blue)),
                        const SizedBox(height: 8),
                        Text(politicianDetails['about']??'N/A',
                            style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Strengths",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 6),
                                  strength.isEmpty ?Text("No Strengths listed",
                                      style: TextStyle(color: Colors.grey)) :Column(
                                    children: strength.map((value)=> ListTile(
                                      leading: Icon(Icons.check_circle,
                                          color: Colors.green),
                                      title: Text(value??''),
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),).toList()
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Areas for Improvement",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(height: 6),
                                  improvement.isEmpty ? Text("No improvements listed",
                                      style: TextStyle(color: Colors.grey)):
                                  Column(
                                    children: improvement.map((value)=>ListTile(
                                      leading: Icon(Icons.check_circle,
                                          color: Colors.green),
                                      title: Text(value??''),
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                    )).toList(),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// Conclude Message
                  if(conclude_message.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                        )
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Conclude Message",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.blue)),
                        SizedBox(height: 8),
                        Column(
                          children: conclude_message.map((value)=>Card(
                            color: Color(0xFFDFF6E0),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                value??'null',
                                style: TextStyle(color: Colors.black87),
                              ),
                            ),
                          ),).toList(),
                        ),
                        SizedBox(height: 8),
                        Card(
                          color: Color(0xFFDFF6E0),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Icon(Icons.campaign, color: Colors.green),
                                SizedBox(width: 6),
                                Expanded(
                                    child: Text(
                                        "Positive change in our community. IN",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green))),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// Public Reviews
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     boxShadow: [
                  //       BoxShadow(
                  //         offset: Offset(0, 4),
                  //         color: Colors.black.withValues(alpha: 0.2),
                  //         blurRadius: 8,
                  //       )
                  //     ],
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   padding: const EdgeInsets.all(16),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       const Text("Public Reviews",
                  //           style: TextStyle(
                  //               fontWeight: FontWeight.w600,
                  //               fontSize: 16,
                  //               color: Colors.blue)),
                  //       DropdownButton<String>(
                  //         value: "Recent",
                  //         underline: const SizedBox(),
                  //         items: const [
                  //           DropdownMenuItem(value: "Recent", child: Text("Recent")),
                  //           DropdownMenuItem(value: "Oldest", child: Text("Oldest")),
                  //           DropdownMenuItem(
                  //               value: "Highest", child: Text("Highest Rating")),
                  //           DropdownMenuItem(
                  //               value: "Lowest", child: Text("Lowest Rating")),
                  //         ],
                  //         onChanged: (value) {},
                  //       )
                  //     ],
                  //   ),
                  // ),

                  PublicReviewsWidget(
            reviews: reviews,
                    scrollController: _scrollController,
                    id: widget.id,
            ),
                ],
              ),
            ),
          );
        }else{
          return Center(
            child: Text('Something went wrong !!'),
          );
        }
          }
      ),
    );
  }

  double _getValueFromPercentage(double percentage,) {
    return (percentage / 100) * 1;
  }
}



class StarRating extends StatefulWidget {
  final int maxStars;
  final double initialRating;
  final Color color;
  final double size;
  final bool isReadOnly;
  final ValueChanged<int>? onRatingChanged;

  const StarRating({
    super.key,
    this.maxStars = 5,
    this.initialRating = 0,
    this.color = Colors.amber,
    this.size = 28,
    this.isReadOnly = false,
    this.onRatingChanged,
  });

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late int currentRating;

  @override
  void initState() {
    super.initState();
    currentRating = widget.initialRating.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxStars, (index) {
        final starIndex = index + 1;
        return GestureDetector(
          onTap: widget.isReadOnly
              ? null
              : () {
            setState(() {
              currentRating = starIndex;
            });
            if (widget.onRatingChanged != null) {
              widget.onRatingChanged!(currentRating);
            }
          },
          child: Icon(
            starIndex <= currentRating ? Icons.star : Icons.star_border,
            color: widget.initialRating == 0 && currentRating == 0 ? Colors.grey:widget.color,
            size: widget.size,
          ),
        );
      }),
    );
  }
}



class PublicReviewsWidget extends StatefulWidget {
  final List<dynamic> reviews;
  final String id;
  final ScrollController scrollController;

  const PublicReviewsWidget({
    super.key,
    required this.reviews,
    required this.id,
    required this.scrollController
  });

  @override
  State<PublicReviewsWidget> createState() => _PublicReviewsWidgetState();
}

class _PublicReviewsWidgetState extends State<PublicReviewsWidget> {
  List<dynamic> sortedReviews = [];
  int _currentIndex = 1;
  bool _isLoading = false;
  bool _hasNext = true;
  String? selectedSort = 'Recent';

  List<dynamic> _getSortedReviews({String? sortBy,required List<dynamic> reviews}) {

    DateTime _parseDate(String? date) {
      if (date == null || date.isEmpty) {
        return DateTime.fromMillisecondsSinceEpoch(0);
      }

      try {
        final formatted = date.contains(" ") ? date.replaceFirst(" ", "T") : date;
        return DateTime.parse(formatted);
      } catch (_) {
        return DateTime.fromMillisecondsSinceEpoch(0);
      }
    }

    // final sorted = [...widget.reviews];

    switch (sortBy) {
      case "Highest":
        reviews.sort((a, b) =>
            (b["rating"] ?? 0).compareTo(a["rating"] ?? 0));
        break;

      case "Lowest":
        reviews.sort((a, b) =>
            (a["rating"] ?? 0).compareTo(b["rating"] ?? 0));
        break;

      case "Oldest":
        reviews.sort((a, b) =>
            _parseDate(a["created_at"]).compareTo(_parseDate(b["created_at"])));
        break;

      case "Recent":
      default:
        reviews.sort((a, b) =>
            _parseDate(b["created_at"]).compareTo(_parseDate(a["created_at"])));
    }

    return reviews;
  }

  void _fetchFeedback()async{
    setState(() {
      _isLoading = true;
    });
    final data = await PoliticianDetailsAPI(context: context).getPoliticianFeedbackList(id: widget.id, page: _currentIndex.toString());
    if(data != null){
      final reviews = data['data']??<dynamic>[];
      sortedReviews.addAll(_getSortedReviews(reviews: reviews,sortBy: selectedSort));
      _currentIndex++;
      _hasNext = data['pagination']['has_next']??false;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // sortedReviews = _getSortedReviews(sortBy: selectedSort);
    _fetchFeedback();
    widget.scrollController.addListener((){
      if(widget.scrollController.position.pixels == widget.scrollController.position.maxScrollExtent && !_isLoading && _hasNext){
        _fetchFeedback();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener((){});
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
              )
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Public Reviews",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
              DropdownButton<String>(
                value: selectedSort,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: "Recent", child: Text("Recent")),
                  DropdownMenuItem(value: "Oldest", child: Text("Oldest")),
                  DropdownMenuItem(value: "Highest", child: Text("Highest Rating")),
                  DropdownMenuItem(value: "Lowest", child: Text("Lowest Rating")),
                ],
                onChanged: (value){
                  setState(() {
                    selectedSort = value;
                    sortedReviews = _getSortedReviews(sortBy: selectedSort ,reviews: sortedReviews);
                  });
                },
              )
            ],
          ),
        ),

        const SizedBox(height: 12),

        /// Reviews List
        // ...sortedReviews.map((review) {
        //   return Container(
        //     margin: const EdgeInsets.only(bottom: 12),
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(12),
        //       boxShadow: [
        //         BoxShadow(
        //           offset: const Offset(0, 2),
        //           color: Colors.black.withValues(alpha: 0.1),
        //           blurRadius: 4,
        //         )
        //       ],
        //     ),
        //     padding: const EdgeInsets.all(16),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         /// Name + Rating row
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Text(
        //               review["name"] ?? "",
        //               style: const TextStyle(
        //                 fontWeight: FontWeight.bold,
        //                 fontSize: 14,
        //               ),
        //             ),
        //             Row(
        //               children: List.generate(
        //                 5,
        //                     (index) => Icon(
        //                   index < (review["rating"] ?? 0)
        //                       ? Icons.star
        //                       : Icons.star_border,
        //                   color: Colors.amber,
        //                   size: 20,
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //         const SizedBox(height: 8),
        //
        //         /// Comment
        //         Text(
        //           review["comment"] ?? "",
        //           style: const TextStyle(fontSize: 14, color: Colors.black87),
        //         ),
        //
        //         const SizedBox(height: 8),
        //
        //         /// Date & Ago
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Text(
        //               review["created_at"] ?? "",
        //               style: const TextStyle(
        //                 fontSize: 12,
        //                 color: Colors.grey,
        //               ),
        //             ),
        //             Text(
        //               review["created_ago"] ?? "",
        //               style: const TextStyle(
        //                 fontSize: 12,
        //                 color: Colors.grey,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   );
        // }).toList(),

        ListView.builder(
          itemCount: sortedReviews.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context,index){
              final review = sortedReviews[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 2),
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                    )
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Name + Rating row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review["name"] ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: List.generate(
                            5,
                                (index) => Icon(
                              index < (review["rating"] ?? 0)
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    /// Comment
                    Text(
                      review["comment"] ?? "",
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),

                    const SizedBox(height: 8),

                    /// Date & Ago
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review["created_at"] ?? "",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          review["created_ago"] ?? "",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
        ),
        if(_isLoading)...[
          CustomCircularIndicator()
        ]
      ],
    );
  }
}




class FeedbackForm extends StatefulWidget {
  final VoidCallback? onSubmit;
  final String politicianId;


  const FeedbackForm({super.key, this.onSubmit,required this.politicianId});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  int _rating = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
            )
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Submit Your Feedback",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue)),
            const SizedBox(height: 12),

            /// Name
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),

            /// Rating
            const Text("Rating",
                style: TextStyle(fontWeight: FontWeight.w600)),
            StarRating(
              initialRating: _rating.toDouble(),
              color: Colors.amber,
              size: 30,
              isReadOnly: false,
              onRatingChanged: (rating) {
                setState(() => _rating = rating);
              },
            ),
            const SizedBox(height: 12),

            /// Message
            TextFormField(
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Please enter comment';
                }
                if(value.length < 4){
                  return 'Comment should be between 3 and 150 characters';
                }
                return null;
              },
              controller: _messageController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Share your experience...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),

            /// Submit Button
            _isLoading ? CustomCircularIndicator():ElevatedButton.icon(
              onPressed: _onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                minimumSize: const Size(double.infinity, 48),
              ),
              icon: const Icon(Icons.send),
              label: const Text("Submit Feedback"),
            )
          ],
        ),
      ),
    );
  }



  void _onSubmit()async {
    if(!(_formKey.currentState?.validate()??false)){
      return;
    }
    if(_rating == 0){
      CustomMessageDialog.show(context,title: 'Rating Required',message: 'Please give your rating..');
      return;
    }

    setState(() {
      _isLoading = true;
    });
    final data = await PoliticianDetailsAPI(context: context).createPoliticianFeedback(name: _nameController.text,rating: _rating.toString(), comment: _messageController.text.trim(), politicianId: widget.politicianId);
    if(data != null){
      final message = data['message']??'';
      CustomMessageDialog.show(context, title: 'Feedback Submit', message: message);
      widget.onSubmit?.call();
    }
    setState(() {
      _rating = 0;
      _nameController.text = '';
      _messageController.text = '';
      _isLoading = false;
    });

  }
}
