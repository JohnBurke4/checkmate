import 'package:checkmate/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/account.dart';

class SwipeCard extends StatefulWidget {
  final User user;
  const SwipeCard({Key? key, required this.user}) : super(key: key);

  @override
  _SwipeCardState createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  int i = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.5),
              blurRadius: 20.0, // soften the shadow
              spreadRadius: -30.0, //extend the shadow
              offset: Offset(
                0.0, // Move horizontally
                -5.0, // Move vertically
              ),
            )
          ],
        ),
        child: Column(children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      if (widget.user.imagePaths.length > 1) {
                        setState(() {
                          i = (i + 1) % widget.user.imagePaths.length;
                        });
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: double.infinity,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image(
                            image: NetworkImage((widget
                                    .user.imagePaths.isNotEmpty
                                ? widget.user.imagePaths[i]
                                : "https://wpstorelocator.co/wp-content/uploads/2016/07/settings-gmap-api-error-2.gif")),
                            fit: BoxFit.fill,
                          )),
                    )),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(
                      //   height: 5,
                      // ),
                      Text(
                        widget.user.name,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        widget.user.abilityLevel,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 65, 65, 65),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'About me:',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 97, 97, 97),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        widget.user.bio,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ]));
  }
}
