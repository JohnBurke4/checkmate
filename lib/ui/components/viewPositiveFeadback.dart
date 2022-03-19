// This Class is used to allow the current user to View his feadback left by others

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewPositiveFeadback extends StatelessWidget {
  final String uid;

  const ViewPositiveFeadback({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('user').doc(uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 23, 29, 43))));
          }

          if (snapshot.hasData) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Row(
              children: <Widget>[
                Expanded(
                    child: Row(children: <Widget>[
                  GestureDetector(
                      child: const Icon(
                        Icons.tag_faces_sharp,
                        size: 30.0,
                        color: Colors.blue,
                      ),
                      onLongPressStart: (DetailsElement) {
                        showMenu<String>(
                            context: context,
                            position: RelativeRect.fromLTRB(
                                DetailsElement.globalPosition.dx,
                                DetailsElement.globalPosition.dy,
                                0.0,
                                0.0), //position where you want to show the menu on screen
                            items: [
                              const PopupMenuItem<String>(
                                child: Text(
                                    'Number of unique commendations received for being Friendly'),
                              )
                            ]);
                      }),
                  Text(data['friendliness'].toString())
                ])),
                Expanded(
                    child: Row(children: <Widget>[
                  GestureDetector(
                      child: const Icon(
                        Icons.access_time,
                        size: 30.0,
                        color: Colors.blue,
                      ),
                      onLongPressStart: (DetailsElement) {
                        showMenu<String>(
                            context: context,
                            position: RelativeRect.fromLTRB(
                                DetailsElement.globalPosition.dx,
                                DetailsElement.globalPosition.dy,
                                0.0,
                                0.0), //position where you want to show the menu on screen
                            items: [
                              const PopupMenuItem<String>(
                                child: Text(
                                    'Number of unique commendations received for being Punctual'),
                              )
                            ]);
                      }),
                  Text(data['punctuality'].toString())
                ])),
                Expanded(
                    child: Row(children: <Widget>[
                  GestureDetector(
                      child: const Icon(
                        Icons.calendar_month,
                        size: 30.0,
                        color: Colors.blue,
                      ),
                      onLongPressStart: (DetailsElement) {
                        showMenu<String>(
                            context: context,
                            position: RelativeRect.fromLTRB(
                                DetailsElement.globalPosition.dx,
                                DetailsElement.globalPosition.dy,
                                0.0,
                                0.0), //position where you want to show the menu on screen
                            items: [
                              const PopupMenuItem<String>(
                                child: Text(
                                    'Number of unique people want to hang out with this dude again'),
                              )
                            ]);
                      }),
                  Text(data['hangOutAgain'].toString())
                ])),
              ],
            );
          }
          return Container();
        });
  }
}
