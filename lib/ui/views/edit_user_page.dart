import 'package:checkmate/getChessELO.dart';
import 'package:checkmate/ui/components/gallery.dart';
import 'package:checkmate/services/match.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../firebase_options.dart';
import 'package:checkmate/ui/components/gallery.dart';
import 'user_page.dart';
import 'dart:io';
import 'package:checkmate/models/user.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User? user = User('', '');
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController bioController = TextEditingController(text: "");
  TextEditingController ageController = TextEditingController(text: "");

  @override
  void initState() {
    // TODO: implement initState
    User? currentUser = DefaultFirebaseOptions.user;
    user = currentUser ?? User("", "");
    user?.id = auth.FirebaseAuth.instance.currentUser?.uid;
    user?.email = auth.FirebaseAuth.instance.currentUser?.email;
    if (user?.abilityLevel == "beginner") user?.abilityLevel = "Beginner";
    nameController.text = user?.name ?? "Enter your name";
    bioController.text = user?.bio ?? "Enter your bio";
    //String? uid = currentUser?.id;
    getProfilePics();
    super.initState();
  }

  Future<void> _showImageDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('You Must Have A Profile Picture.'),
                Text('\nPlease add at least one image to your profile.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showBioNameDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('You Must Have A Bio and a Name.'),
                Text('\nPlease add these to your profile before exiting.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _update(test) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // if (ModalRoute.of(context)!.settings.arguments != null) {
    //
    // }

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
            const SizedBox(height: 15),
            SizedBox(
              height: 160,
              child: Gallery(),
            ),
            SizedBox(height: 2),
            ImageFromGallery(update: _update),
            SizedBox(height: 2),
            Container(
              //alignment: Alignment.topRight,
              padding: EdgeInsets.only(left: 10),
              width: 600,

              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Full Name'),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: EdgeInsets.only(left: 10),
              width: 600,
              child: TextFormField(
                controller: bioController,
                maxLines: 2,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Bio'),
              ),
            ),
            const SizedBox(height: 14),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 25),
                child: Text("Ability Level", textAlign: TextAlign.right)),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 15),
                child: DropdownButton<String>(
                  value: user?.abilityLevel,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      user?.abilityLevel = newValue!;
                    });
                  },
                  items: <String>[
                    "Beginner",
                    "Intermediate",
                    "Advanced",
                    "Master"
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )),
            // TextFieldWidget(
            //   label: 'Email',
            //   text: user.email,
            //   onChanged: (email) {},
            // ),
            const SizedBox(height: 14),
            SizedBox(
              height: 25,
              child: ELOButton(),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(
                Icons.save_alt,
                size: 24.0,
              ),
              label: Text('Confirm'),
              // style: ButtonStyle(
              //   foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              // ),
              onPressed: () async {
                user?.name = nameController.text;
                user?.bio = bioController.text;
                String? images = user?.imagePaths.toString();
                print(images);
                //String? uid = user?.id;
                getProfilePics();
                //user?.imagePaths = [];
                if (user?.name == "" || user?.bio == "") {
                  _showBioNameDialog();
                } else if (images == '[]') {
                  _showImageDialog();
                } else {
                  await DefaultFirebaseOptions.uploadUserDetails(user);
                  Navigator.pop(context, user);
                }
              },
              //child: Text('Confirm Changes'),
            )
            // TextFieldWidget(
            //   label: 'About',z
            //   text: user.about,
            //   maxLines: 5,
            //   onChanged: (about) {},
            // ),
          ],
        ));
  }
}
