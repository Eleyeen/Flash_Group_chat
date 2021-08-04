import 'package:flash_chat/components/input_text_field.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool showSpinner = false;

  AnimationController animationController;
  Animation animation;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);

    animationController.forward();
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: animation.value * 200,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 28.0,
              ),
              InPutTextField(
                onChange: (value) {
                  email = value;
                },
                hintText: 'Enter a Email',
                color: Colors.grey,
              ),
              SizedBox(
                height: 5.0,
              ),
              InPutTextField(
                onChange: (value) {
                  password = value;
                },
                hintText: 'Enter a Password',
                color: Colors.grey,
              ),
              SizedBox(
                height: 14.0,
              ),
              RoundedButtons(
                onPress: () async {
                  setState(() {
                    showSpinner = true;
                    print(email);
                    print(password);
                  });
                  try {
                    final newUser = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      Navigator.pushNamed(context, HomePage.id);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
                color: Colors.lightBlueAccent,
                text: 'Log In',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
