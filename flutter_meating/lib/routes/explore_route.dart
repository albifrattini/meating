import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExploreRoute extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ExploreRouteState();

}

class _ExploreRouteState extends State<ExploreRoute> {

  String url = "https://firebasestorage.googleapis.com/v0/b/meating-live.appspot.com/o/3IUGSy8FYZa2WBg2o5SKekX0lQ431551364995687?alt=media&token=2a5596eb-2f59-41d5-815d-5e81f0c9426e";
  String url2 = "https://firebasestorage.googleapis.com/v0/b/meating-live.appspot.com/o/prova.jpg?alt=media&token=9ef8db60-84d2-4c09-a50d-2675dac54288";
  String url3 = "https://firebasestorage.googleapis.com/v0/b/meating-live.appspot.com/o/gattino.jpg?alt=media&token=1051b3c4-5033-4cb7-9d41-deee515afc4a";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Container(
          padding: EdgeInsets.only(top: 5.0),
          child: MaterialButton(color: Colors.white,
            elevation: 3.0,
            onPressed: () => print("Search"),
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
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: StreamBuilder(
          stream: Firestore.instance.collection('events').snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return Center(child: CircularProgressIndicator(),);
            } else {
              print(snapshot.data.documents.length);
              return ListView.builder(
                  itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
                  itemCount: snapshot.data.documents.length,
                  padding: EdgeInsets.all(10.0),
              );
            }
          },
        ),
      ),
    );
  }
  
  Widget buildItem(int index, DocumentSnapshot document) {
    return Container(
      height: 300.0,
      child: InkWell(
        onTap: () => print("Ciao ancora"),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 0.0),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    AspectRatio(aspectRatio: 25.0 / 11.0, child: Image.network(url3, fit: BoxFit.fitWidth,),),
                    SizedBox(height: 55.0,),
                    Container(padding: EdgeInsets.all(5.0), child: Text(document['name'] + " " + document['surname'], style: TextStyle(fontSize: 20.0),)),
                    Text(document['eventName'], style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                    SizedBox(height: 5.0,),
                    Container(padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),child: Text(document['description'], overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
              CircleAvatar(backgroundImage: NetworkImage(url), radius: 50.0,),
            ],
          ),
        ),
      ),
    );
  }
}
