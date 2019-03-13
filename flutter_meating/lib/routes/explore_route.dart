import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_meating/ui/event_card.dart';
import 'package:flutter_meating/ui/explore_app_bar.dart';
import 'package:flutter_meating/routes/city_filtering_screen.dart';
import 'package:flutter_meating/routes/event_route.dart';



class ExploreRoute extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ExploreRouteState();

}

class _ExploreRouteState extends State<ExploreRoute> with SingleTickerProviderStateMixin{
  
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
  
  _navigateToSearch() async {
    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => CityFilteringScreen()));
    print(result);
  }

  Widget normalAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Container(
        padding: EdgeInsets.only(top: 5.0),
        child: MaterialButton(color: Colors.white,
          elevation: 3.0,
          onPressed: () => _navigateToSearch,
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),child: Icon(Icons.search)),
                Text("Search for a city...")
              ],
            ),
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSearching == false ? 
      AppBar(
        actions: <Widget>[
        IconButton(icon: Icon(Icons.tune), onPressed: () {}),
        IconButton(icon: Icon(Icons.search), onPressed: () {setState(() {
          isSearching = true;});})],) 
          : AppBar(title: TextField(), backgroundColor: Colors.white,),
      body: ListView(
        children: <Widget>[
          //ExploreAppBar(onTap: () => _navigateToSearch(),),
          Container(height: 20.0,),
          listEvents()
        ],
      ),
    );
  }

  Widget listEvents() {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
      child: StreamBuilder(
        stream: Firestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(),);
          } else {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              padding: EdgeInsets.all(10.0),
            );
          }
        },
      ),
    );
  }
  
  Widget buildItem(int index, DocumentSnapshot document) {
    return Container(
      padding: EdgeInsets.only(bottom: 15.0, left: 8.0, right: 8.0),
      child: EventCard(
        hostName: document['hostName'],
        eventName: document['eventName'],
        eventDescription: document['eventDescription'],
        photoURL: document['photoURL'],
        profilePicURL: document['profilePicURL'],
        onTap: _navigateToEvent,
      ),
    );
  }

  _navigateToEvent() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EventRoute()));
  }
}
