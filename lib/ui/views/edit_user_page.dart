import 'package:checkmate/gallery.dart';
import 'package:checkmate/services/match.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../firebase_options.dart';
import 'user_page.dart';
import 'package:checkmate/models/user.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User user = User('', '', 0,chessAbility.Beginner);
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController bioController = TextEditingController(text: "");
  TextEditingController ageController = TextEditingController(text: "");


  @override
  Widget build(BuildContext context) {
    if (user.name == '') {
      print("widget build");
      User temp = ModalRoute.of(context)!.settings.arguments as User;
      user.id = auth.FirebaseAuth.instance.currentUser?.uid;
      user.email = auth.FirebaseAuth.instance.currentUser?.email;
      user.name = temp.name;
      user.bio = temp.bio;
      user.age = temp.age;
      user.abilityLevel = temp.abilityLevel;
      nameController.text = user.name;
      bioController.text = user.bio;
      ageController.text = user.age.toString();
    }

    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Edit Profile')),
          automaticallyImplyLeading: false,
        ),
        resizeToAvoidBottomInset: false, //new line
        body: Column(
          children: [
            // ProfileWidget(
            //   imagePath: user.imagePath,
            //   isEdit: true,
            //   onClicked: () async {},
            // ),
            const SizedBox(height: 30),
            SizedBox(
              height: 160,
              child: Gallery(),
            ),
            SizedBox(height: 2),
            ImageFromGallery(),
            SizedBox(height: 2),
            Container(
              //alignment: Alignment.centerRight,
              //padding: EdgeInsets.only(left:10),
              width: 200,
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Full Name'),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: EdgeInsets.only(left: 10),
              width: 600,
              child: TextFormField(
                controller: bioController,
                maxLines: 4,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Bio'),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: EdgeInsets.only(left: 10),
              width: 600,
              child: TextFormField(
                controller: ageController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Age'),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: EdgeInsets.only(left: 10),
              width: 600,
              child: DropdownButton<String>(
                value: user.abilityLevel.name,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                underline: Container(
                  height: 2,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    user.abilityLevel = GetEnum(newValue);
                  });
                },
                items: <String>["Beginner", "Intermediate", "Advanced", "Master"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )
            ),
            // TextFieldWidget(
            //   label: 'Email',
            //   text: user.email,
            //   onChanged: (email) {},
            // ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {
                user.name = nameController.text;
                user.bio = bioController.text;
                user.age = int.parse(ageController.text);
                print(user.abilityLevel);
                DefaultFirebaseOptions.uploadUserDetails(user);
                Navigator.pop(context, user);
              },
              child: Text('Confirm Changes'),
            )
            // TextFieldWidget(
            //   label: 'About',
            //   text: user.about,
            //   maxLines: 5,
            //   onChanged: (about) {},
            // ),
          ],
        ));
  }

  Enum GetEnum(String? val){
    switch(val){
      case 'Beginner':
        return chessAbility.Beginner;
      case 'Intermediate':
        return chessAbility.Intermediate;
      case 'Experienced':
        return chessAbility.Experienced;
      default:
        return chessAbility.Master;
    }
  }
}
