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
    return Card(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (widget.user.imagePaths.length > 1){
                setState(() {

                  i = (i + 1) % widget.user.imagePaths.length;
                });
              }

            },
            child: Container(
              height: MediaQuery.of(context).size.height*0.5,
              width: double.infinity,
              child: Image(
                image: AssetImage(widget.user.imagePaths[i]),
                fit: BoxFit.fill,
              ),
            )
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Center(
                child: Text(
                  widget.user.name,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Ability: " + widget.user.abilityLevel.name,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  "Bio",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  widget.user.bio,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
