import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';
import '../models/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

List<String> urlImages = [
  'https://imageio.forbes.com/specials-images/imageserve/61499e784c9631d3af55ed22/Magnus-Carlsen-Mastercard-promotional-headshot/960x0.jpg?fit=bounds&format=jpg&width=960',
  'https://upload.wikimedia.org/wikipedia/commons/e/ec/FIDE_World_FR_Chess_Championship_2019_-_Magnus_Carlsen_%28cropped%29.jpg',
  'https://upload.wikimedia.org/wikipedia/commons/a/aa/Carlsen_Magnus_%2830238051906%29.jpg',
  'https://images.chesscomfiles.com/uploads/v1/news/895104.ba7ca489.668x375o.37bd1f5b4a08.jpeg',
];

List<File> _galleryImages = [];

String? profileImage;

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: InkWell(
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white,
              //backgroundImage: NetworkImage(urlImages.first),
              //backgroundImage:
              //  AssetImage('assets/test/blank-profile-picture.png'),
              //backgroundImage: NetworkImage(profileImage),
              backgroundImage: (!_galleryImages.isEmpty)
                  ? FileImage(_galleryImages.first)
                  : AssetImage('assets/test/blank-profile-picture.png')
                      as ImageProvider,
            ),
            onTap: openGallery,
          ),
        ),
      );

  void openGallery() => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => GalleryWidget(
          //urlImages: urlImages,
          galleryImages: _galleryImages,
        ),
      ));
}

class GalleryWidget extends StatefulWidget {
  final PageController pageController;
  //final List<String> urlImages;
  final List<File> galleryImages;
  final index;

  GalleryWidget({
    Key? key,
    //required this.urlImages,
    required this.galleryImages,
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
          //itemCount: widget.urlImages.length,
          itemCount: widget.galleryImages.length,
          builder: (context, index) {
            //final urlImage = widget.urlImages[index];
            final galleryImage = widget.galleryImages[index];

            return PhotoViewGalleryPageOptions(
              //imageProvider: NetworkImage(urlImage),
              imageProvider: FileImage(galleryImage),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.contained * 2,
            );
          },
        ),
      );
}

class ImageFromGallery extends StatefulWidget {
  ImageFromGallery({Key? key}) : super(key: key);

  @override
  //_ImageFromGalleryState createState() => _ImageFromGalleryState();
  _ImageFromGalleryState createState() => _ImageFromGalleryState();
}

class _ImageFromGalleryState extends State<ImageFromGallery> {
  late File imageFile;
  @override
  Widget build(BuildContext context) => Container(
        height: 45,
        child: InkWell(
          child: TextButton(
            child: const Text('Edit Photos'),
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () => _openGallery(),
          ),
        ),
      );

  Future _openGallery() async {
    final picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (picture != null) {
        imageFile = File(picture.path);
        //_uploadFile();
        _galleryImages.add(imageFile);
      }
    });
  }

  Future _uploadFile() async {
    User user = User('', '');
    user.id = auth.FirebaseAuth.instance.currentUser?.uid;
    user.email = auth.FirebaseAuth.instance.currentUser?.email;

    final fileName = path.basename(imageFile.path);
    user.imagePaths.add(fileName);
    DefaultFirebaseOptions.uploadUserDetails(user);

    var ref = auth.FirebaseAuth.instance.currentUser?.uid;
    getUserProfilePicture(ref);
  }

  static void getUserProfilePicture(String? userID) async {
    print('FIREBASE IS THE BEST THING EVER HOLY SHIT');
    var doc =
        await FirebaseFirestore.instance.collection("user").doc(userID).get();
    var data = doc.get('imagePath');
    profileImage = data.getData();
  }
}
