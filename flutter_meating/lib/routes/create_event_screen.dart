import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateEventScreen extends StatefulWidget {

  final String userId;
  final String name, surname, profilePicURL;

  CreateEventScreen({this.userId, this.name, this.surname, this.profilePicURL});

  @override
  createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {

  TextEditingController _textNameController = new TextEditingController();
  TextEditingController _textDescriptionController = new TextEditingController();
  TextEditingController _textCityController = new TextEditingController();

  String photoURL = '';
  File imageFile;
  bool imageLoaded;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          textField(_textNameController, 'Name'),
          textField(_textDescriptionController, 'Description'),
          textField(_textCityController, 'City'),
          ListTile(title: Text('Upload picture'), subtitle: Text('Use a picture to describe your event'),
            trailing: imageLoaded == true ? Icon(Icons.done) : IconButton(icon: Icon(Icons.add), onPressed: getImage,),),
          RaisedButton(onPressed: _uploadIntoDatabase, child: Text('Done'),)
        ],
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
      imageLoaded = true;
      setState(() {});
    });
  }

  _uploadIntoDatabase() async {
    String eventId = DateTime.now().millisecondsSinceEpoch.toString() + '-' + widget.userId;
    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
          Firestore.instance.collection('events').document(eventId),
          {
            'eventId' : eventId,
            'hostName' : widget.name,
            'hostSurname' : widget.surname,
            'eventName' : _textNameController.text,
            'eventDescription' : _textDescriptionController.text,
            'eventCity' : _textCityController.text,
            'profilePicURL' : widget.profilePicURL,
            'photoURL' : photoURL,
          }
      );
    });
    Navigator.pop(context);
  }

  Widget textField(TextEditingController controller, String hintText) {
    return TextField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: controller,
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        hintText: hintText,
        filled: true,
      ),
    );
  }
}