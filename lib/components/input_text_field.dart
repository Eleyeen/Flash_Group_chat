import 'package:flutter/material.dart';


class InPutTextField extends StatelessWidget {
   InPutTextField({@required this.hintText,this.color,@required this.onChange,this.obscureTxt});
 final String hintText;
  final Color color;
  final Function onChange;
  final bool obscureTxt;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged:onChange,
      textAlign: TextAlign.center ,
      style: TextStyle(
        color: Colors.black,

      ),
      
      decoration: InputDecoration(
        
        hintText: hintText,
        
        hintStyle: TextStyle(
          color: color  ),
        
        contentPadding:
            EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.lightBlueAccent, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.lightBlueAccent, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
    );
  }
}
