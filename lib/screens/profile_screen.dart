import 'package:flutter/material.dart';
import 'package:mandman/models/user.dart';
import 'package:mandman/screens/edit_profile.dart';
import 'package:mandman/utils/user_prefs.dart';
import 'package:mandman/widgets/app_drawer.dart';
import 'package:mandman/widgets/profile_appbar.dart';
import 'package:mandman/widgets/profile_widget.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {

    final user=UserPrefs.myUser;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 24),
          ProfileWidget(

            imagePath: user.imagePath,
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          buildName(user),
          const SizedBox(height: 24),
          TextButton(onPressed: (){
            Navigator.of(context).pushNamed(
                EditProfile.routeName);
          }, child:
          Text('Edit Profile',style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 16),
          ),

          )


          // buildAbout(user),
        ],
      ),


    );
  }
}
Widget buildName(User user) => Column(
  children: [
    Text(
      user.username,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
    ),
    const SizedBox(height: 4),
    Text(
      user.email,
      style: TextStyle(color: Colors.grey),
    )
  ],
);



// Widget buildAbout(User user) => Container(
//   padding: EdgeInsets.symmetric(horizontal: 48),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         'Location',
//         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//       ),
//       const SizedBox(height: 16),
//       Text(
//         user.pharmaLocation,
//         style: TextStyle(fontSize: 16, height: 1.4),
//       ),
//     ],
//   ),
// );
