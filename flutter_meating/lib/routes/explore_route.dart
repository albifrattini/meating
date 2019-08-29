import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_meating/routes/event_route.dart';
import 'package:flutter_meating/ui/trending_event_card.dart';



class ExploreRoute extends StatefulWidget {

@override
State<StatefulWidget> createState() => _ExploreRouteState();

}

class _ExploreRouteState extends State<ExploreRoute> with SingleTickerProviderStateMixin{

  final TextEditingController _searchControl = new TextEditingController();

  String _id;
  AnimationController _animationController;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(duration: const Duration(milliseconds: 100), value: 1.0, vsync: this);
  }

  @override
  void dispose () {
    super.dispose();
    _animationController.dispose();
  }
  






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSearching == false ? 
      AppBar(
        title: Text("Home"),
        elevation: 0.0,
      )
          : AppBar(title: TextField(), backgroundColor: Colors.white,),

      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0,20.0,10.0,0),
        child: ListView(
          children: <Widget>[
            //ExploreAppBar(onTap: () => _navigateToSearch(),),
            SearchingBar(),

            SizedBox(height: 20.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child:  Text(
                      "Main Events",
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
            .where('eventDate', isGreaterThanOrEqualTo: _now)
            .orderBy('eventDate')
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

  Widget SearchingBar(){
    return Card(
      elevation: 6.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: TextField(
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Colors.white,),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white,),
              borderRadius: BorderRadius.circular(5.0),
            ),
            hintText: "Search..",
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            suffixIcon: Icon(
              Icons.filter_list,
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              fontSize: 15.0,
              color: Colors.black,
            ),
          ),
          maxLines: 1,
          controller: _searchControl,
        ),
      ),
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
          setState(() {
            _id = document['eventId'];
          });
          _navigateToEvent();
        },
      ),
    );
  }

  _navigateToEvent() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EventRoute(eventId: _id)));
  }
}

