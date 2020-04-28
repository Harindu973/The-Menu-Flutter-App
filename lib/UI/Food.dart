import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:resturant_app/UI/Account.dart';
import 'package:resturant_app/UI/CheckOut.dart';
import 'package:resturant_app/UI/OrderList.dart';
import 'package:resturant_app/UI/OrderObj.dart';
import 'package:resturant_app/model/DataBase.dart';

import 'MainHome.dart';
import 'ProfilePage.dart';

class Food extends StatefulWidget {
  var userID;
 Food(this.userID);
  @override
  _FoodState createState() => _FoodState();
}

class _FoodState extends State<Food> {

  var userID;
  var name='User1';
  var email ='exampe@mail.com';
  var items ='';
  List<OrderObj> UserOrder = new List();

  CheckoutBtn(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CheckOut(UserOrder: UserOrder,)));

  }

  AddItem(var img,var price,var name){

    setState(() {
      UserOrder.add(OrderObj(name: name,img: img,price: price));

    });
  }

  LoadImage()
  async {
    final ref = FirebaseStorage.instance.ref().child('Screenshot_20200426-220422.jpg');
// no need of the file extension, the name will do fine.
    var url = await ref.getDownloadURL();
    print(url);
   // Image.network(LoadImage());
    return url;
  }









  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {

      FirebaseAuth.instance.currentUser().then((userid) {
        Firestore.instance
            .collection('user info')
            .document(userid.uid)
            .get()
            .then((DocumentSnapshot ds) {
          // use ds as a snapshot
          setState(() {
            name = ds['name'];
            email = ds['email'];
          });

        });
      });

    });

  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((userid) {
      Firestore.instance
          .collection('user info')
          .document(userid.uid)
          .get()
          .then((DocumentSnapshot ds) {
        // use ds as a snapshot
        setState(() {
          userID = userid.uid;
          name = ds['name'];
          email = ds['email'];
        });

      });
    });

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.teal,
        ),
      drawer: Drawer(

        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.teal),
                accountName: Text('$name'),
                accountEmail: Text('$email'),
                currentAccountPicture: ClipOval(
                  child: Image.asset(
                    'assets/profile.png',
                    fit: BoxFit.cover,
                  ),
                )),
            ListTile(
              leading: Icon(Icons.person, color: Colors.teal,),
              title: Text('My Account'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite, color:Colors.teal,),
              title: Text('My Favourites'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OrderList(userId:userID)));
              },
            ),
            ListTile(
              leading: Icon(Icons.fastfood, color:Colors.teal,),
              title: Text('Post Yours'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainHome()));
              },
            ),
          ],
        ),
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
                          child: Image.asset('assets/burger.jpg', height: 240,
                            fit: BoxFit.cover,),
                        ),
                        Text('Beef Burger', style: TextStyle(fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.w900),),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('1.2 RO', style: TextStyle(fontWeight: FontWeight.w800),),
                                GestureDetector(
                                  child: Container(

                                    child: Text(
                                      'Get Now', style: TextStyle(fontSize: 16),),
                                    padding: EdgeInsets.only(
                                        top: 2, bottom: 2, right: 5, left: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.teal,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4)),

                                    ),

                                  ),
                                  onTap:() => AddItem('assets/burger.jpg', '1.2', 'Beef Burger') ,
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
                child:RaisedButton(onPressed: () => CheckoutBtn(),
                  child: Text('(${UserOrder.length}) CheckOut',style: TextStyle(fontSize: 24,fontWeight: FontWeight.w400),),
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


