import 'package:checkmate/MockData/Accounts.dart';
import 'package:checkmate/ui/components/swipe_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/draggable_card.dart';
import '../../models/account.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SwipePage extends StatefulWidget {
  @override
  _SwipePageState createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage>
    with TickerProviderStateMixin {



  List<SwipeItem> _swipeItems = List<SwipeItem>.empty(growable: true);
  MatchEngine _matchEngine = MatchEngine();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    for (int i = 0; i < MockAccounts.accounts.length; i++) {
      _swipeItems.add(SwipeItem(
          content: SwipeCard(user: MockAccounts.accounts[i]),
          likeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Liked " +  MockAccounts.accounts[i].name),
              duration: Duration(milliseconds: 500),
            ));
          },
          nopeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Disliked " +  MockAccounts.accounts[i].name),
              duration: Duration(milliseconds: 500),
            ));
          },
          superlikeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Superliked " +  MockAccounts.accounts[i].name),
              duration: Duration(milliseconds: 500),
            ));
          },
          onSlideUpdate: (SlideRegion? region) async {
            //print("Region $region");
          }));
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    return Container(
        height: MediaQuery.of(context).size.height*0.7,
        alignment: Alignment.topCenter,
        child: SwipeCards(
          matchEngine: _matchEngine,
          itemBuilder: (BuildContext context, int index) {
            return _swipeItems[index].content;
          },
          onStackFinished: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Stack Finished"),
              duration: Duration(milliseconds: 500),
            ));
          },
          itemChanged: (SwipeItem item, int index) {
            print("item: hello, index: $index");
          },
          upSwipeAllowed: true,
          fillSpace: false,
        ),
      );
  }
}
    