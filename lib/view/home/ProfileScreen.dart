import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/model/AppUser.dart';
import 'package:survey_app/utilities/cust_colors.dart';
import 'package:survey_app/utilities/custom_dialog/SnackBarHelper.dart';
import 'package:survey_app/widgets/custom_network_image.dart';



class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppUser>(
      builder: (context, user, child) {
        return Scaffold(
          backgroundColor: CustColors.background2,
          appBar: AppBar(
            title: Text("Profile",style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Profile Card
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: CustColors.background_gradient,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6,
                          offset: Offset(0, 4),
                          color: Colors.black.withValues(alpha: 0.1)
                        )
                      ]
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomNetworkImage(
                          imageUrl: user.photo,
                          placeHolder: 'assets/images/dummy_profile.webp',
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 6),
                              Text(
                          user.name ?? "Guest User",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          user.isStaff ? "Staff Member" : "Regular User",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white54,
                          ),
                        ),]
                        )
                      ],
                    ),
                                        ),
                    Positioned(
                      right: 16,
                        top: 16,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.orange.shade400,
                            borderRadius: BorderRadius.circular(8.0)
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 6.0,vertical: 2),
                          child: Text(user.isActive? 'Active':'In Active',style: TextStyle(color: Colors.white),),
                        )
                    )
                  ]
                ),

                const SizedBox(height: 20),
                
                _buildInfoTile('Political Party', Iconsax.people,color: Colors.indigo),
                _buildInfoTile('Candidate', Iconsax.personalcard,color: Colors.orange),
                _buildInfoTile('Legendary Team', Iconsax.profile_2user,color: Colors.purple),
                _buildInfoTile('Contact', Iconsax.message,color: Colors.green),
                _buildInfoTile('About', Iconsax.info_circle,color: Colors.blue),

                const SizedBox(height: 30,),
                // Logout Button
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<AppUser>().reset();
                    SnackBarHelper.show(context, 'Log Out Successfully');
                    Navigator.of(context).pop();
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoTile(String title, IconData icon,{VoidCallback? onTap,Color? color = Colors.indigo}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color),
        title: Text(title),
      ),
    );
  }
  
}
