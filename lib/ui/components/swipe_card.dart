import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/account.dart';

class SwipeCard extends StatelessWidget {
  final Account account;

  const SwipeCard({Key? key, required this.account}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height*0.5,
            width: double.infinity,
            child: Image(
              image: AssetImage(account.PhotoUrl),
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Text(
              account.Name,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
