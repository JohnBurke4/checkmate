import 'package:checkmate/gallery.dart';
import 'package:flutter/material.dart';
import 'user_page.dart';
import 'package:checkmate/models/user.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User user = User('', '');
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController bioController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      User temp = ModalRoute.of(context)!.settings.arguments as User;
      user.name = temp.name;
      user.bio = temp.bio;
      nameController.text = user.name;
      bioController.text = user.bio;
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,   //new line
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
        TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
          ),
          onPressed: () {},
          child: const Text('Edit Photos'),
        ),
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
            decoration:
                InputDecoration(border: OutlineInputBorder(), labelText: 'Bio'),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: EdgeInsets.only(left: 10),
          width: 600,
          child: TextFormField(
            initialValue: 'Experienced (1600+)',
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'Ability Level'),
          ),
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
}
