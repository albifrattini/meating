import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewRoute extends StatefulWidget {

  final String reviewerId;
  final String reviewerName;
  final String reviewerPhotoURL;
  final String reviewUserId;
  final String reviewUserName;

  ReviewRoute({this.reviewerId, this.reviewerName, this.reviewerPhotoURL, this.reviewUserId, this.reviewUserName});

  @override
  createState() => _ReviewRouteState();

}

class _ReviewRouteState extends State<ReviewRoute> {

  TextEditingController _textReviewController = new TextEditingController();
  int rating = -1;
  DateTime reviewDate = DateTime.now();

  @override
  void dispose() {
    super.dispose();
    _textReviewController.dispose();
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
            Text('Give a review to ' + widget.reviewUserName, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: index <= rating ? Icon(Icons.star, color: Colors.amber, size: ScreenUtil.getInstance().setSp(90.0))
                        : Icon(Icons.star_border, color: Colors.amber, size: ScreenUtil.getInstance().setSp(75.0)),
                    color: Colors.transparent,
                    onPressed: () {
                      setState(() {
                        rating = index;
                      });
                    },
                  );
                }),
              ),
            ),
            Container(height: 30.0,),
            textField(_textReviewController, 'Description', TextInputType.multiline),
            Container(height: 30.0,),
            ListTile(trailing: RaisedButton(onPressed: _uploadIntoDatabase, child: Text('Done', style: TextStyle(color: Colors.white, fontSize: 18.0),), color: Color(0xFFEE6C4D),))
          ],
        ),
      ),
    );
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

  _uploadIntoDatabase() async {
    if (_textReviewController.text == '') {
      // TODO: delete image if pop without clicking on "Done"
      return;
    }
    String reviewId = widget.reviewerId + '-' + widget.reviewUserId;
    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
          Firestore.instance.collection('reviews').document(reviewId),
          {
            'reviewDate' : reviewDate,
            'reviewDescription' : _textReviewController.text,
            'reviewRate' : rating,
            'reviewUserId' : widget.reviewUserId,
            'reviewerId' : widget.reviewerId,
            'reviewerName' : widget.reviewerName,
            'reviewerPhotoURL' : widget.reviewerPhotoURL
          }
      );
    });
    Navigator.pop(context);
  }

}