import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:headup_loading/headup_loading.dart';

import 'package:resturant_app/UI/Food.dart';
import 'package:resturant_app/UI/Register.dart';
import 'package:resturant_app/model/DataBase.dart';

import 'package:flutter/material.dart';

import 'package:transparent_image/transparent_image.dart';


import 'Account.dart';

class MainHome extends StatefulWidget {
  @override
  _MainHome createState() => _MainHome();
}

class _MainHome extends State<MainHome>{

  Stream<DocumentSnapshot> provideDocumentFieldStream() {
    return Firestore.instance
        .collection('Items')
        .document('3d7MifURH6UMQmND65Kd')
        .snapshots();

  }
  //String Photo;
 /* LoadImage()
  async {
    final ref = FirebaseStorage.instance.ref().child(Photo);
// no need of the file extension, the name will do fine.
    var url = await ref.getDownloadURL();
    print(url);

    return url;
  }*/




  @override
  Widget build(BuildContext context){

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('FireDemo'),

      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: provideDocumentFieldStream(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              //snapshot -> AsyncSnapshot of DocumentSnapshot
              //snapshot.data -> DocumentSnapshot
              //snapshot.data.data -> Map of fields that you need :)

              Map<String, dynamic> documentFields = snapshot.data.data;
              //TODO Okay, now you can use documentFields (json) as needed

              String foodName = documentFields['foodName'];
              String location =documentFields['location'];
              //Photo =documentFields['photo'];
              String price = documentFields['price'];
              String resturantName =documentFields['resturantName'];

              String imageUrl = documentFields['photo'];

              print(" "+foodName+" "+location+" "+imageUrl+" "+price+" "+resturantName);

              return Scaffold(
                  appBar: AppBar(backgroundColor: Colors.teal,
                  ),

                  body:
                  SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          ConstrainedBox(
                            constraints: BoxConstraints(maxHeight:MediaQuery.of(context).size.height*0.75),
                            child: GridView.count(
                              crossAxisCount: 1,

                              children: <Widget>[
                                Card(
                                  child: Column(
                                    children: <Widget>[

                                      SizedBox(
                                        height: 300,
                                        width: double.infinity,
                                        child: Image.network(
                                          imageUrl,
                                        )

                                      ),
                                      Text(foodName, style: TextStyle(fontSize: 20,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w900),),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 30.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(price, style: TextStyle(fontWeight: FontWeight.w800),),
                                              GestureDetector(
                                                child: Container(

                                                  child: Text(
                                                    'Reviews', style: TextStyle(fontSize: 16),),
                                                  padding: EdgeInsets.only(
                                                      top: 2, bottom: 2, right: 5, left: 5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.teal,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(4)),

                                                  ),

                                                ),
                                               // onTap:() => AddItem('assets/burger.jpg', '1.2', 'Beef Burger') ,
                                              )
                                            ],
                                          )
                                      )

                                    ],
                                  ),
                                ),


                              ],

                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 20,bottom: 20),
                              child:RaisedButton(onPressed: () => Account()/* CheckoutBtn()*/,
                              //  child: Text('(${UserOrder.length}) CheckOut',style: TextStyle(fontSize: 24,fontWeight: FontWeight.w400),),
                                shape:RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0),
                                    side: BorderSide(color: Colors.teal)
                                ),
                                padding: EdgeInsets.symmetric(vertical: 9.0,horizontal: 40.0),
                                color: Colors.teal,
                              )
                          )
                        ],
                      )
                  )
              );

















            }
          }
      )
    );
  }
}