import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'firebase_options.dart';
import 'models/user.dart';

class StoreImage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);
    try {
      await storage.ref('pics/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
    String url = await storage.ref('pics/$fileName').getDownloadURL();
    User? currentUser = DefaultFirebaseOptions.user;
    User user = currentUser ?? User("", "");
    user.id = auth.FirebaseAuth.instance.currentUser?.uid;
    user.email = auth.FirebaseAuth.instance.currentUser?.email;
    user.imagePaths.add(url);
    await DefaultFirebaseOptions.uploadUserDetails(user);
  }

  Future<List> getFirebaseImages() async {
    User? currentUser = DefaultFirebaseOptions.user;
    User user = currentUser ?? User("", "");
    user.id = auth.FirebaseAuth.instance.currentUser?.uid;
    user.email = auth.FirebaseAuth.instance.currentUser?.email;
    User? username =
        await DefaultFirebaseOptions.getUserDetailsAsUser(user) as User;
    List firebaseImages = username.imagePaths;
    return firebaseImages;
  }
}
