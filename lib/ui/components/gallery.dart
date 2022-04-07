import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../firebase_options.dart';
import '../../image_storage.dart';
import '../../models/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

List<String> urlImages = [
  'https://imageio.forbes.com/specials-images/imageserve/61499e784c9631d3af55ed22/Magnus-Carlsen-Mastercard-promotional-headshot/960x0.jpg?fit=bounds&format=jpg&width=960',
  'https://upload.wikimedia.org/wikipedia/commons/e/ec/FIDE_World_FR_Chess_Championship_2019_-_Magnus_Carlsen_%28cropped%29.jpg',
  'https://upload.wikimedia.org/wikipedia/commons/a/aa/Carlsen_Magnus_%2830238051906%29.jpg',
  'https://images.chesscomfiles.com/uploads/v1/news/895104.ba7ca489.668x375o.37bd1f5b4a08.jpeg',
];

List<File> galleryImages = [];
final StoreImage storage = StoreImage();

User user = User("", "");
var firebaseImages = [];

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: FutureBuilder<void>(
              future: getProfilePics(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  print("firebaseImages.first");
                  return InkWell(
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.white,
                      backgroundImage: (firebaseImages.isNotEmpty)
                          ? NetworkImage(firebaseImages.first)
                          : AssetImage('assets/test/blank-profile-picture.png')
                              as ImageProvider,
                    ),
                    onTap: openGallery,
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      );

  void openGallery() => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => GalleryWidget(
          firebaseImages: firebaseImages,
        ),
      ));
}

Future<void> getFirebaseImages() async {
  user.id = auth.FirebaseAuth.instance.currentUser?.uid;
  user.email = auth.FirebaseAuth.instance.currentUser?.email;
  User? username =
      await DefaultFirebaseOptions.getUserDetailsAsUser(user) as User;
  firebaseImages = username.imagePaths;
}

Future getProfilePics() async {
  await getFirebaseImages();
}

class GalleryWidget extends StatefulWidget {
  final PageController pageController;
  final List firebaseImages;
  final index;

  GalleryWidget({
    Key? key,
    required this.firebaseImages,
    this.index = 0,
  })  : pageController = PageController(initialPage: index),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: PhotoViewGallery.builder(
          pageController: widget.pageController,
          scrollDirection: Axis.horizontal,
          itemCount: widget.firebaseImages.length,
          builder: (context, index) {
            final firebaseImage = widget.firebaseImages[index];
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(firebaseImage),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.contained * 2,
            );
          },
        ),
      );
}

class ImageFromGallery extends StatefulWidget {
  final ValueChanged update;
  ImageFromGallery({Key? key,  required this.update}) : super(key: key);


  @override
  _ImageFromGalleryState createState() => _ImageFromGalleryState();
}

class _ImageFromGalleryState extends State<ImageFromGallery> {
  late File imageFile;
  late String imageName;
  late String imagePath;
  @override
  Widget build(BuildContext context) => Container(
        height: 45,
        child: InkWell(
          child: TextButton(
            child: const Text('Edit Photos'),
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () async => await _pictureOptions(),
          ),
        ),
      );

  Future _openGallery() async {
    final picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (picture != null) {
        imageFile = File(picture.path);
        imagePath = picture.path;
        imageName = picture.name;

        storage.uploadFile(imagePath, imageName);
      }
    });
    await getProfilePics();
    setState(() {});
  }

  Future<void> _pictureOptions() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Image Options'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () async {
                  _chooseProfile();
                  Navigator.pop(context);
                },
                child: const Text('Select Display Picture'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  _openGallery();
                  Navigator.pop(context);
                },
                child: const Text('Add to Your Images'),
              ),
            ],
          );
        });
  }

  Future _chooseProfile() async {
    print("Before");
    final picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picture != null) {
      imageFile = File(picture.path);
      imagePath = picture.path;
      imageName = picture.name;
      await storage.uploadFileToFirst(imagePath, imageName);
    }
    await getProfilePics();
    widget.update(1);
  }
}
