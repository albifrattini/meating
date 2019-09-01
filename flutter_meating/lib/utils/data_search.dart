import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_meating/routes/event_route.dart';
import 'package:flutter_meating/ui/trending_event_card.dart';


class DataSearch extends SearchDelegate<String> {

  String id;
  final  cities = [
    "Rome",
  "Milan",
  "Naples",
  "Turin",
  "Florence",
  "Salerno",
  "Palermo",
  "Catania",
  "Genoa",
  "Bari"
  "Bologna",
  "Verona",
  "Pescara",
  "Cagliari",
  "Venice",
  "Messina",
  "Como",
  "Caserta",
  "Trieste",
  "Pisa",
    "Trento",
  "Taranto",
  "Bergamo",
  "Reggio Calabria",
    "Aosta",
    "Perugia",
    "Ancona",
    "Potenza",
    "Catanzaro"
];

  final recentCities = [
    "Milan",
    "Rome",
    "Turin",
    "Florence",
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // actions for appBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },)
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //leading icon
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some result based on the selection
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.fromLTRB(10.0,20.0,10.0,0),
          child: ListView(
              children: <Widget>[

                SizedBox(height: 20.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child:  Text(
                          "Main Events in " + query,
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                listEvents()
              ]
          )

      ),
    );
  }


  Widget listEvents() {

    DateTime _now = DateTime.now();

    return Container(
      child: StreamBuilder(
        stream: Firestore.instance.collection('events')
            .where('eventCity', isEqualTo: query)
            .snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(),);
          } else {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              padding: EdgeInsets.all(10.0),
            );
          }
        },
      ),
    );
  }






  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone search for something
    final suggestionList = query.isEmpty?recentCities:cities.where((p) => p.startsWith(query)).toList();

    return ListView.builder(itemBuilder: (context,index)=>ListTile(
      onTap: (){
        showResults(context);
      },
      leading: Icon(Icons.location_city),
      title: RichText(
        text: TextSpan(
        text: suggestionList[index].substring(0, query.length ),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold
        ),
        children: [
          TextSpan(
            text: suggestionList[index].substring(query.length),
            style: TextStyle(
              color: Colors.grey 
            )
          )
        ]
      ),),
    ),
      itemCount: suggestionList.length,
    );
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    return Container(
      padding: EdgeInsets.only(bottom: 15.0, left: 8.0, right: 8.0),
      child: TrendingEvent(
        hostName: document['hostName'],
        eventName: document['eventName'],
        eventCity: document['eventCity'],
        eventDescription: document['eventDescription'],
        photoUrl: document['photoURL'],
        profilePicUrl: document['profilePicURL'],

        onTap: () {
          id = document['eventId'];//manca il click sull'evento che ti rimanda alla pagina
        },
      ),
    );
  }

}