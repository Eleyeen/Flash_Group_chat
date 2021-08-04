 import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/show_image.dart';
import 'package:flutter/material.dart';

 class HomePage extends StatelessWidget {
     static const String id = 'home_screen';

    HomePage({ Key key }) : super(key: key);

 
   @override
   Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.white,
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
                  text: ['Home Screen'],
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
                  Navigator.pushNamed(context, ChatScreen.id);
                },
                text: 'Chat Screen',

            ),
            RoundedButtons(
              text:  'Upload Image',
              color: Colors.blueAccent,
              onPress: () {
            Navigator.pushNamed(context, ShowImages.id);
          },
              ),
          ],
        ),
      ),
    );
   }
 }