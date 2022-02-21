
//import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'user_page.dart';
//import 'package:user_profile_ii_example/utils/user_preferences.dart';
//import 'package:user_profile_ii_example/widget/appbar_widget.dart';
//import 'package:user_profile_ii_example/widget/button_widget.dart';
//import 'package:user_profile_ii_example/widget/profile_widget.dart';
//import 'package:user_profile_ii_example/widget/textfield_widget.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // User user = UserPreferences.myUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Column(
      children: [
        // ProfileWidget(
        //   imagePath: user.imagePath,
        //   isEdit: true,
        //   onClicked: () async {},
        // ),
        const SizedBox(height: 24),
        Container(

          //alignment: Alignment.centerRight,
          //padding: EdgeInsets.only(left:10),
          width: 200,
          child:
          TextFormField(
            initialValue:'Magnus',
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Full Name'
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(

          padding: EdgeInsets.only(left:10),
          width: 600,
          child:
          TextFormField(
            maxLines: 4,
            initialValue:'My name is Magnus, but my mates call me Mag.\n''I got fed up of winning all the time'
          ' so I thought I would try this app out since I have heard such great things about it.',
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Bio'
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: EdgeInsets.only(left:10),
          width: 600,
          child:
          TextFormField(
            initialValue:'Experienced (1600+)',
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ability Level'
            ),
          ),
        ),
        // TextFieldWidget(
        //   label: 'Email',
        //   text: user.email,
        //   onChanged: (email) {},
        // ),
        const SizedBox(height: 24),
        // TextFieldWidget(
        //   label: 'About',
        //   text: user.about,
        //   maxLines: 5,
        //   onChanged: (about) {},
        // ),
      ],
    ));
  }
}
