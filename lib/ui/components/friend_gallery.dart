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

List<File> galleryImages = [];
final StoreImage storage = StoreImage();

User user = User("", "");
var friendFirebaseImages = [];

class FriendGallery extends StatefulWidget {
  final String? uid;
  const FriendGallery({Key? key, this.uid}) : super(key: key);

  @override
  _FriendGalleryState createState() => _FriendGalleryState();
}

class _FriendGalleryState extends State<FriendGallery> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: InkWell(
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white,
                backgroundImage: (friendFirebaseImages.isNotEmpty)
                    ? NetworkImage(friendFirebaseImages.first)
                    : AssetImage('assets/test/blank-profile-picture.png')
                        as ImageProvider,
              ),
              onTap: openFriendGallery),
        ),
      );

  // Future<void> getFirebaseImagesForFriend(String? uid) async {
  //   user.id = uid;
  //   User? username =
  //       await DefaultFirebaseOptions.getUserDetailsAsUser(user) as User;
  //   friendFirebaseImages = username.imagePaths;
  //   print(friendFirebaseImages);
  // }

  // void getFriendProfilePics(String? uid) async {
  //   await getFirebaseImagesForFriend(uid);
  // }

  void openFriendGallery() => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => FriendGalleryWidget(
          friendFirebaseImages: friendFirebaseImages,
        ),
      ));
}

Future<void> getFirebaseImagesForFriend(String? uid) async {
  var doc = await FirebaseFirestore.instance.collection("user").doc(uid).get();
  var data = doc.data();
  User username = User.fromJSON(data!);
  friendFirebaseImages = username.imagePaths;
}

void getFriendProfilePics(String? uid) async {
  await getFirebaseImagesForFriend(uid);
}

class FriendGalleryWidget extends StatefulWidget {
  final PageController pageController;
  final List friendFirebaseImages;
  final index;

  FriendGalleryWidget({
    Key? key,
    required this.friendFirebaseImages,
    this.index = 0,
  })  : pageController = PageController(initialPage: index),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _FriendGalleryWidgetState();
}

class _FriendGalleryWidgetState extends State<FriendGalleryWidget> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: PhotoViewGallery.builder(
          pageController: widget.pageController,
          scrollDirection: Axis.horizontal,
          itemCount: widget.friendFirebaseImages.length,
          builder: (context, index) {
            final friendFirebaseImage = widget.friendFirebaseImages[index];
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(friendFirebaseImage),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.contained * 2,
            );
          },
        ),
      );
}
