import 'package:checkmate/firebase_options.dart';
import 'package:checkmate/tournament.dart';
import 'package:checkmate/tournamentInfo.dart';
import 'package:checkmate/widget_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:checkmate/reusable_widgets/reusable_widget.dart';
import 'package:checkmate/reset_password.dart';
import 'package:checkmate/sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateTournamentPage extends StatefulWidget {
  const CreateTournamentPage({
    Key? key,
    required this.lat,
    required this.lon,
    this.tournamentId

  }) : super(key: key);
  final double lat;
  final double lon;
  final String? tournamentId;

  @override
  _CreateTournamentPageState createState() => _CreateTournamentPageState();
}

class _CreateTournamentPageState extends State<CreateTournamentPage> {
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _sizeTextController = TextEditingController();
  TextEditingController _detailsTextController = TextEditingController();
  TextEditingController _dateTextController = TextEditingController();
  TourInfo? tour;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<TourInfo?>(
        future: getTournamentInfo(widget.tournamentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done){
            tour = snapshot.data;
            _nameTextController.text = tour?.tournamentName ?? "";
            _sizeTextController.text = tour?.tournamentSize.toString() ?? "";
            _detailsTextController.text = tour?.details ?? "";
            _dateTextController.text = tour?.date ?? "";
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).size.height * 0.10, 20, 0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                        child: Center(
                          child: Text(
                            (widget.tournamentId == null)?"New tournament": "Edit Tournament",
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                      Container(
                        //alignment: Alignment.topRight,
                        padding: EdgeInsets.only(left: 10),
                        width: 600,

                        child: TextFormField(
                          controller:
                          _nameTextController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: 'Tournament Name'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      Container(
                        padding: EdgeInsets.only(left: 10),
                        width: 600,
                        child: TextFormField(
                          controller: _sizeTextController,
                          maxLines: 1,
                          decoration: const InputDecoration(

                              border: OutlineInputBorder(), labelText: 'Number of Players?'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        width: 600,
                        child: TextFormField(
                          controller: _dateTextController,
                          maxLines: 1,
                          decoration: const InputDecoration(

                              border: OutlineInputBorder(), labelText: 'Date and Time'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        width: 600,
                        child: TextFormField(
                          controller: _detailsTextController,
                          maxLines: 3,
                          decoration: const InputDecoration(

                              border: OutlineInputBorder(), labelText: 'Other Details?'),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColorDark,
                          ),
                          foregroundColor:
                          MaterialStateProperty.all<Color>(
                              Colors.white),
                        ),
                        onPressed: () async {
                          if (_nameTextController.text.isNotEmpty &&
                              _sizeTextController.text.isNotEmpty &&
                              _dateTextController.text.isNotEmpty &&
                              _detailsTextController.text.isNotEmpty) {
                            var size = int.tryParse(_sizeTextController.text);
                            if (size == null || size < 1 || size > 32) {
                            } else {
                              if (widget.tournamentId == null){
                                Tournament.createTournament(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    DefaultFirebaseOptions.user?.name ?? "Hidden",
                                    widget.lat,
                                    widget.lon,
                                    _nameTextController.text,
                                    size,
                                    _dateTextController.text,
                                    _detailsTextController.text);

                              } else{

                                await Tournament.UpdateTournament(
                                    TourInfo(
                                        author_name: tour!.author_name,
                                        author_id: tour!.author_id,
                                        tournamentName: _nameTextController.text,
                                        tournamentSize: size,
                                        players: tour!.players,
                                        date: _dateTextController.text,
                                        details: _detailsTextController.text)
                                , widget.tournamentId);
                              }

                              Navigator.of(context).pop();
                            }
                          }
                        },
                        child: Text('Confirm'),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColorDark,
                          ),
                          foregroundColor:
                          MaterialStateProperty.all<Color>(
                              Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Change Location'),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    );
  }

  Future<TourInfo?> getTournamentInfo(String? tournamentID) async {
    if (tournamentID == null){
      return null;
    }
    TourInfo info = TourInfo(
        author_id: "nothing now",
        author_name: 'nothing_now',
        tournamentName: 'nothing_now',
        tournamentSize: 0,
        details: "",
        date: "TBD",
        players: []);
    await FirebaseFirestore.instance
        .collection("tournaments")
        .doc(tournamentID)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      var data = documentSnapshot.data() as Map<String, dynamic>;

      info = TourInfo(
          details: data['details'] ?? "",
          date: data['date'] ?? "TBD",
          author_id: data['author'],
          author_name: data['authorName'] ?? "Unknown",
          tournamentName: data['name'],
          tournamentSize: data['size'],
          players: data['players']);
      //print(documentSnapshot.data().toString());
    });

    if (info.players.isEmpty == false) {
      info.players.forEach((element) {
        if (element == info.author_id) {}
      });
    }
    return info;
  }



}
