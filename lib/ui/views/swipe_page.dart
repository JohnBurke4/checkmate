import 'package:checkmate/MockData/Accounts.dart';
import 'package:checkmate/services/match.dart';
import 'package:checkmate/ui/components/swipe_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/draggable_card.dart';
import '../../models/account.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SwipePage extends StatefulWidget {
  @override
  _SwipePageState createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> with TickerProviderStateMixin {
  List<SwipeItem> _swipeItems = List<SwipeItem>.empty(growable: true);
  MatchEngine _matchEngine = MatchEngine();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState()  {

    super.initState();
  }

  void GetNewUsers(accounts) {
    List<SwipeItem> tempSwipeItems = List<SwipeItem>.empty(growable: true);
    // Return type is a List but will need to put into an async function as below
    // List<String> localUserIds = await MatchServices.getLocalUsers(userId, range);
    for (int i = 0; i < accounts.length; i++) {
      _swipeItems.add(SwipeItem(
          content: SwipeCard(user: accounts[i]),
          likeAction: () async {
            await MatchServices.swipeRight(accounts[i].id,
                accounts[i].name, context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Liked " + accounts[i].name),
              duration: const Duration(milliseconds: 500),
            ));
          },
          nopeAction: () async {
            await MatchServices.swipeLeft(accounts[i].id);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Disliked " + accounts[i].name),
              duration: const Duration(milliseconds: 500),
            ));
          },
          superlikeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Superliked " + accounts[i].name),
              duration: const Duration(milliseconds: 500),
            ));
          },
          onSlideUpdate: (SlideRegion? region) async {
            //print("Region $region");
          }));

    }
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      alignment: Alignment.topCenter,
      child: FutureBuilder(
        future: MatchServices.getLocalUsers(20),
        builder: (context, AsyncSnapshot<List<dynamic>> value) {
          if (value.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (value.hasData) {
            if (value.data?.isEmpty ?? true){
              return const Center(
                child: Text(
                  "There are no users near you, please try again later.",
                  textAlign: TextAlign.center,
                ),
              );
            }
            else{
              GetNewUsers(value.data);
              return SwipeCards(
                matchEngine: _matchEngine,
                itemBuilder: (BuildContext context, int index) {
                  return _swipeItems[index].content;
                },
                onStackFinished: () {
                  _matchEngine = MatchEngine();
                  _swipeItems.clear();
                  setState(() {});
                },
                itemChanged: (SwipeItem item, int index) {
                },
                upSwipeAllowed: true,
                fillSpace: false,
              );
            }

          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    );
  }
}
