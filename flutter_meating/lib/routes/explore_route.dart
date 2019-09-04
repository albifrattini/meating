import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_meating/routes/event_route.dart';
import 'package:flutter_meating/ui/trending_event_card.dart';
import 'package:flutter_meating/utils/data_search.dart';
import 'package:device_info/device_info.dart';


class ExploreRoute extends StatefulWidget {

@override
State<StatefulWidget> createState() => _ExploreRouteState();

}

class _ExploreRouteState extends State<ExploreRoute> with SingleTickerProviderStateMixin{

  final TextEditingController _searchControl = new TextEditingController();

  String _id;
  AnimationController _animationController;
  bool isSearching = false;
  bool isIpad = false;

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

    checkIpad();

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
            return isIpad == false ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
                          itemCount: snapshot.data.documents.length,
                          padding: EdgeInsets.all(10.0),
            ) : GridView.builder(
                          itemCount: snapshot.data.documents.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (Orientation.portrait == Orientation.portrait) ? 2 : 3),
                          itemBuilder: (BuildContext context, int index) => buildItem(index, snapshot.data.documents[index]),
                          padding: EdgeInsets.all(10.0),
          );
          }
        },
      ),
    );
  }

  void checkIpad() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo info = await deviceInfo.iosInfo;
    if (info.name.toLowerCase().contains("ipad")) {
      isIpad = true;
    } else {
      isIpad = false;
    }
    setState(() {
    });
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
          onTap: (){
            showSearch(context: context, delegate: DataSearch());
          },
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
            prefixIcon: IconButton(
            icon:Icon(
              Icons.search,
              color: Colors.black,
            ),
              onPressed: () {
          showSearch(context: context, delegate: DataSearch());
          },
            ),
          ),
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
        placesAvailable: document['placesAvailable'],
        eventDate: document['eventDate'],
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => EventRoute(eventId: _id, bookable: true,)));
  }
}

