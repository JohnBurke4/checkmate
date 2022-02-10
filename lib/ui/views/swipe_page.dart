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

  List<String> welcomeImages = [
    "assets/test/tinderSample1.jpg",
    "assets/test/tinderSample2.jpg",
    "assets/test/tinderSample3.jpg",
    "assets/test/tinderSample4.jpg",
  ];

  List<SwipeItem> _swipeItems = List<SwipeItem>.empty(growable: true);
  MatchEngine _matchEngine = MatchEngine();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<String> _names = ["Red", "Blue", "Green", "Yellow", "Orange"];
  List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange
  ];

  @override
  void initState() {
    for (int i = 0; i < welcomeImages.length; i++) {
      _swipeItems.add(SwipeItem(
          content: SwipeCard(account: Account(Name:"John", PhotoUrl: welcomeImages[i])),
          likeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Liked John"),
              duration: Duration(milliseconds: 500),
            ));
          },
          nopeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Nope John"),
              duration: Duration(milliseconds: 500),
            ));
          },
          superlikeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Superliked John"),
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
        height: MediaQuery.of(context).size.height*0.6,
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
    