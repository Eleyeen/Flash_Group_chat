import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class AddImage extends StatefulWidget {
  const AddImage({Key key}) : super(key: key);
  static const String id = 'AddIamge_screen';

  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  List<File> _image = [];
  final picker = ImagePicker();
  CollectionReference imgRef;
  firebase_storage.StorageReference ref;
  double val = 0;
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Image'),
          actions: [
            FlatButton(
              onPressed: () {
                setState(() {
                  uploading = true;
                });
                uploadImage().whenComplete(() => Navigator.of(context).pop());
              },
              child: Text(
                'upload',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton (
             child: Icon(Icons.add),
                          onPressed: () {
                            chooseImage();
                          },
                        ),
        body: Stack(
          children: <Widget>[
             
            
            GridView.builder(
                itemCount: _image.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return Container(
                        height: 20.0,
                        width: 20.0,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            image: DecorationImage(
  
                                image: FileImage(_image[index + 0]),
                                
                                fit: BoxFit.cover),
                          ),
                        );
                }),
            uploading
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text(
                          'uploading..',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      CircularProgressIndicator(
                        value: val,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ],
                  ))
                : Container(),
         
          ],
       
        )
         
                        
        );
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      );

    setState(() {
      _image.add(File(pickedFile?.path));
      
    });
    if (pickedFile == null) retrieveLostData();
   
  }

  Future<void> retrieveLostData() async {
    final LostData respones = await picker.getLostData();
    if (respones.isEmpty) {
      return;
    }
    if (respones.file != null) {
      setState(() {
        _image.add(File(respones.file.path));

      });
    } else {
      print(respones.file);
    }
  }

  Future uploadImage() async {
    int i = 1;
    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
       ref =  firebase_storage.FirebaseStorage.instance.ref()
       .child('images/${Path.basename(img.path)}');
       
         

      firebase_storage.StorageUploadTask uploadTask = ref.putFile(img);
      firebase_storage.StorageTaskSnapshot taskSnapshot= await uploadTask.onComplete;
      taskSnapshot.ref.getDownloadURL().then((value) {
        imgRef.add({'url':value});
      i++;
      });
        //  await  ref.putFile(img).whenComplete(() async{
        //    await  ref.getDownloadURL().then((value) {
        //      imgRef.add({'url':value});
        //    i++;
        //    });
        //  });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imgRef = Firestore.instance.collection('imageURLs');
  }
}
