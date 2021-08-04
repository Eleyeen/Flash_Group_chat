
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
 static const String id ='welcome_screen'; 
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
       AnimationController animationController;
       Animation animation;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,

    );
    // animation = CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animation = ColorTween(begin: Colors.grey,end: Colors.white).animate(animationController);
    animationController.forward();
    animationController.addListener(() {
      setState(() {
        
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 64.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButtons(
              color: Colors.lightBlueAccent,
              onPress: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                text: 'Log In',

            ),
            RoundedButtons(
              text:  'Register',
              color: Colors.blueAccent,
              onPress: () {
            Navigator.pushNamed(context, RegistrationScreen.id);
          },
              ),
          ],
        ),
      ),
    );
  }
}
