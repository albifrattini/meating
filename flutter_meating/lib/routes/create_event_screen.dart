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
  TextEditingController _textTotalSeatsController = new TextEditingController();
  TextEditingController _textFromTimeController = new TextEditingController();

  DateTime selectedDate = DateTime.now();

  String photoURL = '';
  File imageFile;
  bool imageLoaded = false;
  bool imageIsLoading = false;
  bool dateSelected = false;

  @override
  void dispose() {
    super.dispose();
    _textDescriptionController.dispose();
    _textNameController.dispose();
    _textCityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFFEE6C4D), elevation: 0.0,),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: <Widget>[
            Container(height: 30.0,),
            textField(_textNameController, 'Name', TextInputType.multiline),
            Container(height: 30.0,),
            textField(_textDescriptionController, 'Description', TextInputType.multiline),
            Container(height: 30.0,),
            textField(_textCityController, 'City', TextInputType.text),
            Container(height: 30.0,),
            textField(_textTotalSeatsController, 'Total places available', TextInputType.number),
            Container(height: 30.0,),
            RaisedButton(
              onPressed: () => _selectDate(context),
              child: dateSelected ? Text(selectedDate.day.toString()
                                      +  selectedDate.month.toString()
                                      +  selectedDate.year.toString())
                                  : Text('Select Date')
            ),
            Container(height: 30.0,),
            textField(_textFromTimeController, 'Event starts at...', TextInputType.number),
            Container(height: 30.0,),
            ListTile(title: Text('Upload picture', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),), subtitle: Text('Use a picture to describe your event'),
              trailing: imageIsLoading == true ? CircularProgressIndicator() : imageLoaded == true ? Icon(Icons.done, color: Colors.green, size: 40.0,) : IconButton(icon: Icon(Icons.add, color: Colors.black, size: 30.0,), onPressed: getImage,),),
            Container(height: 30.0,),
            ListTile(trailing: RaisedButton(onPressed: _uploadIntoDatabase, child: Text('Done', style: TextStyle(color: Colors.white, fontSize: 18.0),), color: Color(0xFFEE6C4D),))
          ],
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019),
        lastDate: DateTime(2020));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateSelected = true;
      });
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(imageFile != null) {
      imageIsLoading = true;
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
      imageIsLoading = false;
      imageLoaded = true;
      setState(() {});
    });
  }

  _uploadIntoDatabase() async {
    if (_textCityController.text == '' ||
        _textNameController.text == '' ||
        _textDescriptionController.text == '' ||
        imageFile == null
    ) {
      // TODO: delete image if pop without clicking on "Done"
      return;
    }
    uploadFile();
    String eventId = DateTime.now().millisecondsSinceEpoch.toString() + '-' + widget.userId;
    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
          Firestore.instance.collection('events').document(eventId),
          {
            'eventId' : eventId,
            'hostName' : widget.name,
            'hostId': widget.userId,
            'hostSurname' : widget.surname,
            'eventName' : _textNameController.text,
            'eventDescription' : _textDescriptionController.text,
            'eventCity' : _textCityController.text,
            'totalPlaces': _textTotalSeatsController.text,
            'eventDate': dateSelected,
            'profilePicURL' : widget.profilePicURL,
            'photoURL' : photoURL,
          }
      );
    });
    Navigator.pop(context);
  }

  Widget textField(TextEditingController controller, String hintText, TextInputType keyboard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(hintText, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),),
        Container(height: 20.0,),
        TextField(
          keyboardType: keyboard,
          maxLines: null,
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          ),
        ),
      ],
    );
  }
}