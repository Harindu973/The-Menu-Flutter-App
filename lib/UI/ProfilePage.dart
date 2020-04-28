import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:resturant_app/model/DataBase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'item.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();


}

class _ProfilePageState extends State<ProfilePage> {
  File _image;
  String url;


  TextEditingController ResturantNameController = TextEditingController();
  TextEditingController FoodNameController = TextEditingController();
  TextEditingController LocationController = TextEditingController();
  TextEditingController PriceController = TextEditingController();

  String storeCollectionName = "Items";
  Item currentFood;

  addItem(String uploadedImage) async {
    Item item = Item(resturantName: ResturantNameController.text, foodName: FoodNameController.text, location: LocationController.text, price: PriceController.text, photo: uploadedImage);

    try{

      Firestore.instance.runTransaction(
              (Transaction transaction) async{
            await Firestore.instance
                .collection(storeCollectionName)
                .document()
                .setData(item.toJson());
          }
      );

    }catch(e){
      print(e.toString());
    }


  }








  @override
  Widget build(BuildContext context) {

    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
          print('Image Path $_image');
      });
    }


/*
    Future<String> uploadPic(var imageFile ) async {
      StorageReference ref = storage.ref().child("/photo.jpg");
      StorageUploadTask uploadTask = ref.putFile(imageFile);

      var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      url = dowurl.toString();

      return url;
    }
*/




    Future uploadPic(BuildContext context) async{
       String fileName = basename(_image.path);
       StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
       StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
       var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
       url = dowurl.toString();
       print(url);

        //url = await firebaseStorageRef.getDownloadURL();

       setState(() {
          print("Success");
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Success')));
          addItem(url);
       });
    }

    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.teal,
          leading: IconButton(
              icon: Icon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text('Edit Profile'),
        ),
        body: Builder(
        builder: (context) =>  Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.teal,
                      child: ClipOval(
                        child: new SizedBox(
                          width: 180.0,
                          height: 180.0,
                          child: (_image!=null)?Image.file(
                            _image,
                            fit: BoxFit.fill,
                          ):Image.network(
                            "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 60.0),
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.camera,
                        size: 30.0,
                      ),
                      onPressed: () {
                        getImage();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: ResturantNameController,
                textAlign: TextAlign.left,
                decoration: InputDecoration(hintText: "Restaurant Name",contentPadding: const EdgeInsets.fromLTRB(20,0,0,-15)),
              ),

                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: FoodNameController,
                  decoration: InputDecoration(hintText: "Deviled Checken Pizza",contentPadding: const EdgeInsets.fromLTRB(20,0,0,-15)),
                ),

              SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: LocationController,
                decoration: InputDecoration(hintText: "Homagama",contentPadding: const EdgeInsets.fromLTRB(20,0,0,-15)),
              ),

              SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: PriceController,
                decoration: InputDecoration(hintText: "1599.00",contentPadding: const EdgeInsets.fromLTRB(20,0,0,-15)),
              ),

              SizedBox(
                height: 50.0,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.teal,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    elevation: 4.0,
                    splashColor: Colors.blueGrey,
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.teal,
                    onPressed: () {
                     uploadPic(context);

                    },
                                     
                    elevation: 4.0,
                    splashColor: Colors.blueGrey,
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
              
                ],
              )
            ],
          ),
        ),
        ),
        );
  }
}
