import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/add_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
class ShowImages extends StatefulWidget {
  static const String id = 'shoqImage_screen';

  @override
  _ShowImagesState createState() => _ShowImagesState();
}

class _ShowImagesState extends State<ShowImages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddImage.id);
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('imageURLs').snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    child: GridView.builder(
                        itemCount: snapshot.data.documents.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.all(3),
                            child: FadeInImage.memoryNetwork(
                              fit: BoxFit.cover,
                              placeholder: kTransparentImage,
                              image: snapshot.data.documents[index].get('url')??"",),
                              // child: Image.network(
                              //   snapshot.data.documents[index].get('url') ??"",
                              // ),
                              
                            
                          );
                        }),
                        
                  );
                  
          }),
          
    );
  }
}

// firebase storage k rules
