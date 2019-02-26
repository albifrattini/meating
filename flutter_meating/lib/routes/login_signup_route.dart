import 'package:flutter/material.dart';
import 'package:flutter_meating/utils/authentication.dart';


class LoginSignUpRoute extends StatefulWidget {

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  LoginSignUpRoute({this.auth, this.onSignedIn});

  @override
  State<StatefulWidget> createState() => _LoginSignUpRouteState();

}

class _LoginSignUpRouteState extends State<LoginSignUpRoute> with SingleTickerProviderStateMixin {

  final TextEditingController _userNameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _surnameController = new TextEditingController();
  Animation<double> _imageAnimation;
  AnimationController _imageAnimationController;
  bool _showOverlayPage = false;
  String _overlayMessage = "";
  bool _showOverlayInformations = false;


  // Setting up animation.
  @override
  void initState() {
    super.initState();
    _imageAnimationController = new AnimationController(duration: new Duration(seconds: 2), vsync: this);
    _imageAnimation = new CurvedAnimation(parent: _imageAnimationController, curve: Curves.elasticOut);
    _imageAnimation.addListener(() => this.setState(() {}));
    _imageAnimationController.forward();
  }

  // Clear both TextFields from any text remained inside.
  _clearControllers() {
    _userNameController.clear();
    _passwordController.clear();
    _nameController.clear();
    _surnameController.clear();
  }

  // Is recommended to always dispose controllers after ending the utilization.
  @override
  void dispose () {
    _userNameController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  // This function is called when some values have been entered in TextFields and Login
  // button has been pressed.
  // Firebase is called to validate email and password entered. If .signIn() returns a userId
  // from server, a VoidCallback is performed in RootRoute, else an Error will be shown
  // in the user interface.
  _validateAndLogin() async {
    try {
      String userId = await widget.auth.signIn(_userNameController.text, _passwordController.text);
      if (userId.length > 0 && userId != null) {
        widget.onSignedIn();
      } else {
        print("UserId is == null or .length is == 0");
      }
    } catch(e) {
      print(e);
      setState(() {
        _showOverlayPage = true;
        _overlayMessage = e.toString();
      });
    }
    _clearControllers();
  }

  // This function is called when a user taps on 'Register Now' button, instead of 'Login'.
  // .signUp is called in async way and after the process has ended the page remains the same,
  // suggesting the user to do Login now.
  // TODO: add email verification.
  _insertNewUser() async {
    try {
      String userId = await widget.auth.signUp(_userNameController.text, _passwordController.text, _nameController.text, _surnameController.text);
      print(userId + " inserted into Authentication DB!");
      setState(() {
        _showOverlayPage = true;
        _showOverlayInformations = false;
        _overlayMessage = "Please, verify your email inbox in order to Login!";
      });
    } catch(e) {
      print(e);
      setState(() {
        _showOverlayPage = true;
        _showOverlayInformations = false;
        _overlayMessage = e.toString();
      });
    }
    _clearControllers();
  }

  _showNameSurnameOverlay() {
    _clearControllers();
    setState(() {
      _showOverlayInformations = true;
    });
  }

  Widget _textField(String toShow, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        labelText: toShow,
      ),
    );
  }

  // Widget returning a TextField where email should be inserted
  Widget _emailField() {
    return TextField(
      controller: _userNameController,
      decoration: InputDecoration(
        filled: true,
        labelText: 'Email',
      ),
    );
  }
  // Widget returning a TextField where password should be inserted
  Widget _passwordField() {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
      ),
      obscureText: true, // black dots will appear instead of characters
    );
  }

  // Sets back page without an overlay
  _resetLoginRoute() {
    setState(() {
      _showOverlayPage = false;
      _overlayMessage = "";
    });
  }

  // Returns a widget that displays a page with transparent black on which will appear
  // a message: error if login failed, email verification suggestion if user
  // tapped on 'Register Now'.
  // Page is dismissed when user taps on screen.
  Widget _pageOverlay() {
    return new Material(color: Colors.black54,
      child: InkWell(
        onTap: _resetLoginRoute,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              _overlayMessage,
              style: TextStyle(fontSize: 30.0, color: Colors.redAccent),
            ),
          ),
        ),
      ),
    );
  }

  _dismissInfoOverlay() {
    _clearControllers();
    setState(() {
      _showOverlayInformations = false;
    });
  }

  Widget _informationsOverlay() {
    return new Material(
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 50.0),
              Text("Registration", style: TextStyle(fontSize: 30.0, color: Colors.black), textAlign: TextAlign.center,),
              SizedBox(height: 50.0),
              _textField('Name', _nameController),
              SizedBox(height: 15.0),
              _textField('Surname', _surnameController),
              SizedBox(height: 15.0),
              _emailField(),
              SizedBox(height: 15.0),
              _passwordField(),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    onPressed: () => _dismissInfoOverlay(),
                    child: Text('Back', style: TextStyle(color: Color(0xAA0C6291)),),
                  ),
                  RaisedButton(
                    color: Color(0xFF0C6291),
                    padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    onPressed: () => _insertNewUser(),
                    child: Text('Register', style: TextStyle(color: Colors.white),),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // UI component.
  // A Widget that returns two buttons: one to register with new email and password,
  // the other to Login.
  // When pressed, buttons call different functions inside this Dart file.
  Widget _registerLoginButtons() {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        MaterialButton(
          onPressed: () => _showNameSurnameOverlay(),
          child: Text("Register Now", style: TextStyle(color: Color(0xAA0C6291)),),
        ),
        RaisedButton(
          color: Color(0xFF0C6291),
          padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          onPressed: () => _validateAndLogin(),
          child: Text('Login', style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( // used to put an overlay for error and email verification suggestion
        children: <Widget>[
          SafeArea( // is the Area right under the main top bar (the one with time, battery, notifications...)
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              children: <Widget>[
                SizedBox(height: 100.0),
                Container(
                    height: _imageAnimation.value * 200.0,
                    child: Image.asset('assets/images/meating_logo.png')
                ),
                SizedBox(height: 50.0),
                _emailField(),
                SizedBox(height: 8.0,),
                _passwordField(),
                _registerLoginButtons(),
              ],
            ),
          ),
          _showOverlayPage == true ? _pageOverlay() : new Container(),
          _showOverlayInformations == true ? _informationsOverlay() : new Container()
        ],
      ),
    );
  }
}
