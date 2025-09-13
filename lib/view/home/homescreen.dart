import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/api_service/api_urls.dart';
import 'package:survey_app/main.dart';
import 'package:survey_app/model/AppUser.dart';
import 'package:survey_app/model/LoginUser.dart';
import 'package:survey_app/utilities/consts.dart';
import 'package:survey_app/utilities/cust_colors.dart';
import 'package:survey_app/utilities/custom_dialog/CustomMessageDialog.dart';
import 'package:survey_app/utilities/custom_dialog/SnackBarHelper.dart';
import 'package:survey_app/utilities/location_permisson_handler/LocationPermissionHandler.dart';
import 'package:survey_app/view/auth/CitizenLoginScreen.dart';
import 'package:survey_app/view/home/AboutUsScreen.dart';
import 'package:survey_app/view/home/Chats/ConstituencyChat/ConstituencyChatScreen.dart';
import 'package:survey_app/view/home/EmulatorMockup/EmulatorMockup.dart';
import 'package:survey_app/view/home/FaqContactScreen.dart';
import 'package:survey_app/view/home/OurLegendaryLeadersScreen.dart';
import 'package:survey_app/view/home/ProfileScreen.dart';
import 'package:survey_app/view/home/PublicRepresentative/PublicRepresentativeScreen.dart';
import 'package:survey_app/view/home/RAISE/WithConstituency/WithConstituencyRaiseQueryScreen.dart';
import 'package:survey_app/view/home/RAISE/WithoutConstituency/WithoutConstituencyRaiseQueryScreen.dart';
import 'package:survey_app/view/home/slider/slider_screen.dart';
import 'package:survey_app/widgets/custom_network_image.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'Chats/PublicChat/PublicChatScreen.dart';
import 'PublicRepresentative/PublicRepresentativeSlider.dart';
import 'RepresentativePartySlider.dart';
import 'RepresentativeSection.dart';
import 'StatsSection.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();

  // Global Keys
  final _politicalPartyKey = GlobalKey();
  final _candidateKey = GlobalKey();
  final _legendaryTeamKey = GlobalKey();
  final _contactUsKey = GlobalKey();
  final _faqKey = GlobalKey<FaqContactScreenState>();
  final _aboutKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((duration){
      getProfileDetailsFromAPI();
      getLocationPermission(context);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustColors.background2,
      appBar: AppBar(
        backgroundColor: CustColors.background1,
        centerTitle: true,
        title: Image.asset("assets/images/true-survey-logo.png", scale: 4.1),
      ),
      drawer: _drawerUI(),
      body: GestureDetector(
        onTap: (){
          _faqKey.currentState?.unFocus();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 0),
                  FadeInAnimation(
                    delay: 0.5,
                    child: SizedBox(height: 220, child: SliderScreen()),
                  ),
                  const Divider(height: 0.5,color: Colors.white70,),
                  SlideInAnimation(
                    direction: SlideDirection.right,
                    delay: 0.7,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: CustColors.background1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'ईमानदार और पारदर्शी समीक्षा से लोकतंत्र को मजबूत बनाएं — एक बेहतर और ताकतवर देश के लिए मिलकर कदम बढ़ाएं।',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SlideInAnimation(
                                direction: SlideDirection.left,
                                delay: 0.9,
                                child: ElevatedButton(
                                  onPressed: ()async {
                                    final context = _politicalPartyKey.currentContext;
                                    if(context != null){
                                      Scrollable.ensureVisible(
                                        context,
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.easeInOut
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFB800),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Explore Parties",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SlideInAnimation(
                                direction: SlideDirection.right,
                                delay: 1.1,
                                child: OutlinedButton(
                                  onPressed: () {
                                    final context = _contactUsKey.currentContext;
                                    if (context != null) {
                                      Scrollable.ensureVisible(
                                        context,
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.white),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Contact Us",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const EmulatorMockup(),
                  FadeInAnimation(delay: 1.3, child: StatsSection()),
                  const SizedBox(height: 10),
                  SlideInAnimation(
                    direction: SlideDirection.left,
                    delay: 1.5,
                    child: PublicRepresentativeSlider(
                      onPressed: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PublicRepresentativeScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SlideInAnimation(
                    key: _candidateKey,
                    direction: SlideDirection.up,
                    delay: 1.6,
                    child: const RepresentativeSection(),
                  ),
                  FadeInAnimation(key: _politicalPartyKey,
                      delay: 1.7, child: RepresentativePartySlider()),

                  SlideInAnimation(
                    key: _legendaryTeamKey,
                    direction: SlideDirection.up,
                      delay: 1.9,
                      child: OurLegendaryLeadersScreen()
                  ),
                  FaqContactScreen(key: _faqKey,contactUsKey: _contactUsKey,),
                  AboutUsScreen(key: _aboutKey,),
                ],
              ),
            ),
          ),
        ),
      ),

      // ✨ Floating Action Button (FAB)
      floatingActionButton: Consumer2<AppUser,LoginUser>(
        builder: (context,appUser,loginUser,child){
          return SpeedDial(
            icon: Icons.add,
            activeIcon: Icons.close,
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            overlayColor: Colors.black,
            overlayOpacity: 0.3,
            spacing: 10,
            spaceBetweenChildren: 8,
            children: [
              if(appUser.isLogin)...[
                SpeedDialChild(
                  child: const Icon(Icons.map,color: Colors.white,),
                  backgroundColor: Colors.indigo,
                  label: loginUser.constituencyName!=null && loginUser.constituencyName?.name != null ? '${loginUser.constituencyName!.name} Query' :'Constituency Query',
                  labelStyle: const TextStyle(fontSize: 14),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context)=>
                                loginUser.status?.key??false ?
                                WithConstituencyRaiseQueryScreen(
                                  constituencyId: loginUser.constituencyName!= null && loginUser.constituencyName?.id != null ? (loginUser.constituencyName?.id).toString():'',)
                                    : ProfileScreen(),
                        )
                    );
                    if(!(loginUser.status?.key??false)){
                      CustomMessageDialog.show(context, title: 'Complete Profile', message: 'Complete your profile to chat with your constituency');
                    }
                  },
                ),
                SpeedDialChild(
                  child: const Icon(Icons.forum,color: Colors.white,),
                  backgroundColor: Colors.deepPurple,
                  label: loginUser.constituencyName!=null && loginUser.constituencyName?.name != null ? '${loginUser.constituencyName!.name} Chat':'Constituency Chat',
                  labelStyle: const TextStyle(fontSize: 14),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context)=>
                            loginUser.status?.key??false ?
                                ConstituencyChatScreen(constituencyId: loginUser.constituencyName!= null && loginUser.constituencyName?.id != null ? (loginUser.constituencyName?.id).toString():'',)
                                : ProfileScreen()
                        )
                    );

                    if(!(loginUser.status?.key??false)){
                      CustomMessageDialog.show(context, title: 'Complete Profile', message: 'Complete your profile to raise constituency Query.');
                    }
                  },
                ),
              ],
              SpeedDialChild(
                child: const Icon(Icons.question_mark,color: Colors.white,),
                backgroundColor: const Color(0xFF0054D3),
                label: 'Raise Query',
                labelStyle: const TextStyle(fontSize: 14),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WithoutConstituencyRaiseQueryScreen()));
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.chat_bubble_outline,color: Colors.white,),
                backgroundColor: const Color(0xFF00A97F),
                label: 'Public Chat',
                labelStyle: const TextStyle(fontSize: 14),
                onTap: ()async {
                  final status = await getLocationPermission(context);
                  if(status == LocationPermissionStatus.granted){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context)=> PublicChatScreen()));
                  }else{
                    CustomMessageDialog.show(context, title: 'Warning', message: 'Please allow location to access public chat !!');
                  }
                },
              ),
            ],
          );
        },
      ),
      onDrawerChanged: (isOpen){
        _faqKey.currentState?.unFocus();
      },
    );
  }

  Drawer _drawerUI() {
    return Drawer(
      child: Container(
        color: CustColors.background2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(12,12,12,4),
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: CustColors.background1,
              ),
              child: SafeArea(
                  child: Consumer<AppUser>(
                    builder: (BuildContext context, AppUser value, Widget? child) {
                      return  value.isLogin ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomNetworkImage(
                            height: 130,
                            width: 130,
                            imageUrl: value.photo,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          const SizedBox(height: 4.0,),
                          Text(value.name??'N/A',style: TextStyle(fontSize: 18,color: Colors.white),),
                          const SizedBox(height: 4,),
                          OutlinedButton.icon(
                            onPressed: ()async{
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
                            },
                            label: Text('View Profile'),
                            icon: Icon(Iconsax.profile_circle),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.deepOrange,
                            ),
                          )
                        ],
                      ) : Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () async{
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CitizenLoginScreen(
                                onLoginSuccess: ()async{
                                  getProfileDetailsFromAPI();
                                },
                              )));
                            },
                            icon: Icon(Icons.login),
                            label: Text("Login"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.white
                              )
                            ),
                          ),
                          const SizedBox(height: 8,),
                          Text('Login to True Survey',style: TextStyle(color: Colors.white,fontSize: 18),),
                        ],
                      );
                    },
                  ),
              ),
            ),
            const Divider(height: 0.5,),
            ListView(shrinkWrap: true,
                padding: EdgeInsets.all(12),
                children: [
                  _buildInfoTile('Political Party', Iconsax.people,color: Colors.indigo,onTap: (){_scrollTo(_politicalPartyKey);}),
                  _buildInfoTile('Candidate', Iconsax.personalcard,color: Colors.orange,onTap: (){_scrollTo(_candidateKey);}),
                  _buildInfoTile('Legendary Team', Iconsax.profile_2user,color: Colors.purple,onTap: (){_scrollTo(_legendaryTeamKey);}),
                  _buildInfoTile('Contact', Iconsax.call,color: Colors.teal,onTap: (){_scrollTo(_contactUsKey);}),
                  _buildInfoTile('Freq Asked Question', Iconsax.message,color: Colors.green,onTap: (){_scrollTo(_faqKey);}),
                  _buildInfoTile('About', Iconsax.info_circle,color: Colors.blue,onTap: (){_scrollTo(_aboutKey);}),
                  const SizedBox(height: 20,),
                  // Logout Button
              Consumer<AppUser>(
                builder: (BuildContext context, AppUser value, Widget? child) {
                  if(value.isLogin){
                    return ElevatedButton.icon(
                      onPressed: () {
                        context.read<AppUser>().reset();
                        context.read<LoginUser>().reset();
                        SnackBarHelper.show(context, 'Log Out Successfully');
                        // Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }else{
                    return const SizedBox();
                  }
                },
              ),
            ]),
            // version & powered by
            Spacer(),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Version 1.0',style: TextStyle(color: Colors.grey),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Powered by ',style: TextStyle(color: Colors.grey),),
                      const SizedBox(width: 2,),
                      Image.asset('assets/powered_by/powered_by_logo.webp',width: 40,height: 40,fit: BoxFit.contain,)
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, IconData icon,{VoidCallback? onTap,Color? color = Colors.indigo}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color),
      title: Text(title),
    );
  }

  void _scrollTo(GlobalKey key) async{
    final context = key.currentContext;
    if (context != null) {
      Navigator.of(context).pop();
      // await Future.delayed(Duration(milliseconds: 1000));
      Scrollable.ensureVisible(
        context,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> getProfileDetailsFromAPI()async{
    final isLogin = prefs.getBool(Consts.isLogin)??false;
    if(!isLogin){
      return;
    }
    final accessToken = prefs.getString(Consts.accessToken);
    try{
      final url = Uri.https(Urls.baseUrl,Urls.getProfileDetails);
      final response = await get(url,headers: {
        'Authorization' : 'Bearer $accessToken',
        'content-type' :'Application/json'
      });
      print('Response code: ${response.statusCode},Body: ${response.body}');
      if(response.statusCode == 200){
        final data = json.decode(response.body) as Map<String,dynamic>;
        final status = data['success']??false;
        if(status){
          final values = data['data'];
          prefs.setString(Consts.name, '${values['first_name'].toString()} ${values['last_name'].toString()}');
          prefs.setString(Consts.photo,values['photo']??'');
          context.read<LoginUser>().update(values);
          context.read<AppUser>().update(
            photo: prefs.getString(Consts.photo),
            name: prefs.getString(Consts.name),
          );
        }
      }
    }catch(exception,trace){
      print('Exception: ${exception} Trace: ${trace}');
    }

  }

}



enum SlideDirection { left, right, up, down }

class FadeInAnimation extends StatelessWidget {
  final Widget child;
  final double delay;

  const FadeInAnimation({super.key, required this.child, this.delay = 0.0});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: (500 + delay * 1000).toInt()),
      curve: Curves.easeInOut,
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(opacity: value, child: child);
      },
      child: child,
    );
  }
}

class SlideInAnimation extends StatelessWidget {
  final Widget child;
  final SlideDirection direction;
  final double delay;

  const SlideInAnimation({
    super.key,
    required this.child,
    this.direction = SlideDirection.left,
    this.delay = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    Offset getBeginOffset() {
      switch (direction) {
        case SlideDirection.left:
          return const Offset(-100, 0);
        case SlideDirection.right:
          return const Offset(100, 0);
        case SlideDirection.up:
          return const Offset(0, 100);
        case SlideDirection.down:
          return const Offset(0, -100);
      }
    }

    return TweenAnimationBuilder(
      tween: Tween<Offset>(begin: getBeginOffset(), end: Offset.zero),
      duration: Duration(milliseconds: (600 + delay * 1000).toInt()),
      curve: Curves.easeOutQuart,
      builder: (BuildContext context, Offset value, Widget? child) {
        return Transform.translate(offset: value, child: child);
      },
      child: child,
    );
  }
}

void _showRaiseProblemDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Raise New Problem',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Problem Title',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Describe your problem...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            const Text(
              'Attach File (Optional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                // Handle file selection
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.attach_file, size: 20),
                    SizedBox(width: 8),
                    Text('Choose file'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'No file chosen',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // Handle submit
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Problem submitted successfully'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}
