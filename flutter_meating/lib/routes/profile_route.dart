import 'package:flutter/material.dart';
import 'package:flutter_meating/routes/attending_events_route.dart';
import 'package:flutter_meating/utils/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_meating/routes/my_events_route.dart';

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
  String language = 'EN';

  bool _showSettingsOverlay = false;
  bool _showBiographyOverlay = false;
  bool _showPasswordChangeOverlay = false;
  bool _showErrorOverlay = false;
  String errorMessage = '';
  bool imageIsLoading = false;
  bool hideOldPassword = true;
  bool hideNewPassword = true;
  TextEditingController _textBiographyController = new TextEditingController();

  TextEditingController _textPasswordOldController = new TextEditingController();
  TextEditingController _textPasswordNewController = new TextEditingController();

  File imageFile;

  @override
  void initState() {
    super.initState();
  }

  Widget _settingsOverlay() {
    return Material(
      color: Theme.of(context).canvasColor,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              trailing: IconButton(icon: Icon(Icons.clear, size: 30.0,), onPressed: () => _setFalseSettingsOverlay()),
            ),
            SizedBox(height: 30.0,),
            Text(name, style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),
            SizedBox(height: 20.0,),
            Text(surname, style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),
            SizedBox(height: 50.0,),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _textBiographyController,
              decoration: InputDecoration(
                hintText: 'Your biography...',
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
              ),
            ),
            SizedBox(height: 50.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Password", style: TextStyle(fontSize: 20.0),),
                MaterialButton(
                  onPressed: _setTrueChangePasswordOverlay,
                  child: Text("Change", style: TextStyle(fontSize: 15.0, color: Color(0xFF0C6291)),),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Language", style: TextStyle(fontSize: 20.0),),
                MaterialButton(onPressed: _changeLanguage, child: Text(language, style: TextStyle(fontSize: 15.0, color: Color(0xFF0C6291)),),)
              ],
            ),
          ],
        ),
      ),
    );
  }

  _changeLanguage() {
    if (language == 'EN') {
      language = 'IT';
    } else {
      language = 'EN';
    }
    setState(() {});
  }

  _setTrueChangePasswordOverlay() {
    setState(() {
      _showPasswordChangeOverlay = true;
    });
  }

  _setFalseChangePasswordOverlay() {
    _textPasswordNewController.clear();
    _textPasswordOldController.clear();
    setState(() {
      _showPasswordChangeOverlay = false;
    });
  }

  Widget _changePasswordOverlay() {
    return Material(
      color: Theme.of(context).canvasColor,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView(
          children: <Widget>[
            ListTile(trailing: IconButton(icon: Icon(Icons.clear, size: 30.0,), onPressed: _setFalseChangePasswordOverlay),),
            SizedBox(height: 100.0,),
            ListTile(
              title: TextField(
              controller: _textPasswordOldController,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                labelText: 'Current password',
              ),
              obscureText: hideOldPassword,
                ),
              trailing: IconButton(icon: Icon(Icons.remove_red_eye, color: Colors.black,), onPressed: () {setState(() {hideOldPassword == true ? hideOldPassword = false : hideOldPassword = true;});}),
            ),
            SizedBox(height: 30.0,),
            ListTile(
              title: TextField(
                controller: _textPasswordNewController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                  labelText: 'New password',
                ),
                obscureText: hideNewPassword,
              ),
              trailing: IconButton(icon: Icon(Icons.remove_red_eye, color: Colors.black,), onPressed: () {setState(() {hideNewPassword == true ? hideNewPassword = false : hideNewPassword = true;});}),
            ),
            SizedBox(height: 80.0,),
            ListTile(trailing: RaisedButton(onPressed: _updatePassword, child: Text('Done', style: TextStyle(color: Colors.white, fontSize: 18.0),), color: Color(0xFFEE6C4D),)),
          ],
        ),
      ),
    );
  }

  _updatePassword() async {
    if(_textPasswordNewController.text == '') return;
    String _oldPass = _textPasswordOldController.text.trim();
    String _newPass = _textPasswordNewController.text.trim();
    Firestore.instance.collection('users').document(widget.userId).get().then((document) {
      if(document['password'] == _oldPass) {
        Firestore.instance.runTransaction((transaction) async {
          await transaction.update(
          Firestore.instance.collection('users').document(widget.userId),
            {
              'password' : _newPass,
            }
          );
        });
        _setFalseChangePasswordOverlay();
      } else {
        errorMessage = 'The old password you inserted is wrong!';
        _setTrueErrorOverlay();
      }
    });
  }

  _setTrueErrorOverlay() {
    setState(() {
      _showErrorOverlay = true;
    });
  }

  _setFalseErrorOverlay() {
    setState(() {
      _showErrorOverlay = false;
    });
  }

  Widget _errorOverlay() {
    return new Material(color: Colors.black54,
      child: InkWell(
        onTap: _setFalseErrorOverlay,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              errorMessage,
              style: TextStyle(fontSize: 30.0, color: Colors.redAccent),
            ),
          ),
        ),
      ),
    );
  }

  Widget _biographyOverlay() {
    return Material(
      color: Theme.of(context).canvasColor,
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.all(50),
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
              ListTile(trailing: RaisedButton(child: Text("Done", style: TextStyle(color: Colors.black),), onPressed: () => _setFalseBiographyOverlay())),
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
      setState(() {
        imageIsLoading = true;
      });
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
      setState(() {
        imageIsLoading = false;
      });
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
    //widget.auth.signOut();
    //widget.onSignOut();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Profile"),
        leading: IconButton(
            icon: Icon(
              Icons.settings,
              size: 24.0,
              color: Colors.white,),
            onPressed: () => _setTrueSettingsOverlay()),
        actions: <Widget>[
      MaterialButton(child: Text(
        "Log Out",
        style: TextStyle(
          color: Colors.white
        ),),onPressed: () {
        widget.auth.signOut();
        widget.onSignOut();
      }
      ),
        ],
      ),
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
          _showPasswordChangeOverlay == true ? _changePasswordOverlay() : Container(),
          _showErrorOverlay == true ? _errorOverlay() : Container(),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return ListView(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                child: MaterialButton(
                  child: CircleAvatar(
                    backgroundImage: photoURL == '' ? null : NetworkImage(photoURL),
                    radius: ScreenUtil.instance.setWidth(200),
                    backgroundColor: Color(0xFFF38D68),
                    child: imageIsLoading == true ? CircularProgressIndicator() : photoURL == '' ? Text(name[0]+surname[0], style: TextStyle(color: Colors.black),) : null,
                  ),
                  onPressed: getImage,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(name, style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(50), fontWeight: FontWeight.bold)),
                    SizedBox(height: 10.0,),
                    Text(surname, style: TextStyle(fontSize:ScreenUtil.getInstance().setSp(50), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0,),
        //biography == '' ? _addBiography() :
        Center(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Text(
                biography, style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(44)),
            ),
          ),
        ),
        SizedBox(height: 30.0,),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)
                ),
                elevation: 5,
                child: InkWell(
                  onTap: _navigateToAttendingEvents,
                  child: Container(
                    width: ScreenUtil.instance.setWidth(400),
                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil.instance.setWidth(10), vertical: ScreenUtil.instance.setHeight(30)),
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.calendar_today, size: 40.0, color: Colors.red[700],),
                        SizedBox(height: 10.0,),
                        Container(
                          child: Text("Attending", style: TextStyle(fontSize: 15.0),),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)
                ),
                elevation: 5,
                child: InkWell(
                  onTap: _navigateToMyEvents,
                  child: Container(
                    width: ScreenUtil.instance.setWidth(400),
                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil.instance.setWidth(10), vertical: ScreenUtil.instance.setHeight(30)),
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.home, size: 40.0, color: Color(0xFF0C6291),),
                        SizedBox(height: 10.0,),
                        Container(
                          child: Text("My Events", style: TextStyle(fontSize: 15.0),),
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

  _navigateToMyEvents() {
    Navigator.push((context), MaterialPageRoute(builder: (context) => MyEventsRoute(userId: widget.userId, name: name, surname: surname, photoURL: photoURL,)));
  }

  _navigateToAttendingEvents() {
    Navigator.push((context), MaterialPageRoute(builder: (context) => AttendingEventsRoute(userId: widget.userId, name: name, surname: surname, photoURL: photoURL,)));
  }

}