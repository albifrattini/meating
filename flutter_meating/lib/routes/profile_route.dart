import 'package:flutter/material.dart';
import 'package:flutter_meating/utils/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';

class ProfileRoute extends StatefulWidget {

  final VoidCallback onSignOut;
  final BaseAuth auth;
  final String userId;

  ProfileRoute({this.onSignOut, this.auth, this.userId});

  @override
  State<StatefulWidget> createState() => _ProfileRouteState();

}

class _ProfileRouteState extends State<ProfileRoute> {

  String name, surname, photoURL, biography;

  bool _showSettingsOverlay = false;
  bool _showBiographyOverlay = false;
  TextEditingController _textBiographyController = new TextEditingController();

  File imageFile;

  @override
  void initState() {
    super.initState();
  }

  Widget _settingsOverlay() {
    return Material(
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              trailing: IconButton(icon: Icon(Icons.cancel), onPressed: () => _setFalseSettingsOverlay()),
            ),
            SizedBox(height: 30.0,),
            Text(name, style: TextStyle(fontSize: 20.0),),
            SizedBox(height: 20.0,),
            Text(surname, style: TextStyle(fontSize: 20.0),),
            SizedBox(height: 10.0,),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _textBiographyController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Password", style: TextStyle(fontSize: 20.0),),
                MaterialButton(
                  onPressed: () => print("Change password"),
                  child: Text("Change Password", style: TextStyle(fontSize: 15.0),),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Language", style: TextStyle(fontSize: 20.0),),
                MaterialButton(onPressed: () => print("Change language"), child: Text("EN", style: TextStyle(fontSize: 15.0),),)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _biographyOverlay() {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 50.0,),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _textBiographyController,
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                  labelText: 'Tell me something about you...',
                  filled: true,
                ),
              ),
              SizedBox(height: 20.0,),
              RaisedButton(child: Text("Done"), onPressed: () => _setFalseBiographyOverlay()),
            ],
          ),
        ),
      ),
    );
  }

  _setTrueSettingsOverlay () {
    setState(() {
      _showSettingsOverlay = true;
      _textBiographyController.text = biography;
    });
  }

  _setFalseSettingsOverlay() {
    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(
          Firestore.instance.collection('users').document(widget.userId),
          {
            'biography' : _textBiographyController.text,
          }
      );
    });
    setState(() {
      biography = _textBiographyController.text;
      _showSettingsOverlay = false;
    });
  }

  _setTrueBiographyOverlay() {
    setState(() {
      _showBiographyOverlay = true;
    });
  }

  _setFalseBiographyOverlay() {
    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(
          Firestore.instance.collection('users').document(widget.userId),
          {
            'biography' : _textBiographyController.text,
          }
      );
    });
    setState(() {
      biography = _textBiographyController.text;
      _showBiographyOverlay = false;
    });
  }
  
  Widget _addBiography() {
    return Container(
      child: MaterialButton(
        onPressed: () => _setTrueBiographyOverlay(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.control_point),
              Container(
                padding: EdgeInsets.only(left: 15.0),
                child: Text("Add some informations about you"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      uploadFile();
    }
  }

  Future uploadFile () async {
    String fileName = widget.userId + "-" + DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadURL) {
      photoURL = downloadURL;
      _uploadPhotoURL();
      setState(() {});
    });
  }

  _uploadPhotoURL() {
    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(
          Firestore.instance.collection('users').document(widget.userId),
          {
            'photoURL' : photoURL,
          }
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: StreamBuilder(
              stream: Firestore.instance.collection('users').document(widget.userId).snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData) {
                    return Material(child: Center(child: Container(child: CircularProgressIndicator(),),),);
                  } else {
                    DocumentSnapshot user = snapshot.data;
                    name = user['name'];
                    surname = user['surname'];
                    photoURL = user['photoURL'];
                    biography = user['biography'];
                    return _buildProfileView();
                  }
                }),
          ),
          _showSettingsOverlay == true ? _settingsOverlay() : Container(),
          _showBiographyOverlay == true ? _biographyOverlay() : Container(),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return ListView(
      children: <Widget>[
        SafeArea(
          child: Container(
            child: ListTile(
              leading: IconButton(icon: Icon(Icons.settings), onPressed: () => _setTrueSettingsOverlay()),
              trailing: MaterialButton(child: Text("Log Out"),onPressed: () {
                widget.auth.signOut();
                widget.onSignOut();
              }),
            ),
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                child: MaterialButton(
                  child: CircleAvatar(
                    backgroundImage: photoURL == '' ? null : NetworkImage(photoURL),
                    maxRadius: 50.0,
                    backgroundColor: photoURL == '' ? Colors.black12 : null,
                    child: photoURL == '' ? Text(name[0]+surname[0], style: TextStyle(color: Colors.black),) : null,
                  ),
                  onPressed: getImage,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(name, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10.0,),
                    Text(surname, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0,),
        biography == '' ? _addBiography() : Center(child: Container(child: Text(biography),),),
        SizedBox(height: 30.0,),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Card(
                child: InkWell(
                  onTap: () => print("Tapped on favorite Card"),
                  child: Container(
                    width: 150.0,
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.favorite, size: 40.0, color: Colors.red[700],),
                        SizedBox(height: 10.0,),
                        Container(
                          child: Text("Favorite", style: TextStyle(fontSize: 15.0),),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  onTap: () => print("Tapped on attending Card"),
                  child: Container(
                    width: 150.0,
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.home, size: 40.0, color: Color(0xFF0C6291),),
                        SizedBox(height: 10.0,),
                        Container(
                          child: Text("Attending", style: TextStyle(fontSize: 15.0),),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}