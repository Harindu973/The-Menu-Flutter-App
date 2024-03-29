import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:resturant_app/UI/ItemCard.dart';
import 'package:resturant_app/UI/OrderObj.dart';
import 'package:resturant_app/model/DataBase.dart';

class CheckOut extends StatefulWidget {
  List<OrderObj> UserOrder ;
  CheckOut({this.UserOrder});
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  var price = 0.0;
  var item = 0 ;
  var fireDB = DataBase();
  var addition = new List();
  var male = new List();
  var malePrice = new List();
  var delivery='';
  var rating = '1';


  Buy(BuildContext contxt){

    if(widget.UserOrder.isNotEmpty){
   fireDB.addOrder(male: male,price: malePrice,delivery: delivery,totalPrice: price,rating: rating,addition: addition);
   SuccessAlertBox(context: contxt,title: 'Successful',messageText: 'You have Order Successfully');
   widget.UserOrder.clear();
    }else{
      InfoAlertBox(context: contxt,title: 'Alert',infoMessage: 'You dont have any item');
    }

  }

  DeleteIcon(){
    setState(() {
      widget.UserOrder.clear();
      price = 0.0;
    });

  }

  @override
  Widget build(BuildContext context) {
     setState(() {
       item = widget.UserOrder.length;
       for(var i=0;i<widget.UserOrder.length;i++){
         var pric = double.parse(widget.UserOrder[i].price);
         price+=pric;
       }

     });


    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.teal,
      actions: <Widget>[
         IconButton(icon: Icon(Icons.delete), onPressed: ()=>DeleteIcon()),

      ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 20,left: 30),
                child: Text('Items : $item',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),)
              ),
            ),
            ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 80*item.toDouble()),

                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.UserOrder.length,
                    itemBuilder: (context, index) {
                         male.add(widget.UserOrder[index].name);
                         malePrice.add(widget.UserOrder[index].price);
                      return ItemCard(name: widget.UserOrder[index].name, price: widget.UserOrder[index].price,img: widget.UserOrder[index].img,);
                    })
            ),
            Divider(),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 30,top: 10),
                child: Text('addition',style: TextStyle(fontSize: 16),),
              )
            ),
                CheckboxGroup(
                    labels: <String>[
                      "Suce",
                      "Mayo",
                      "Katchap",
                    ],
                    onSelected: (List<String> checked)=>addition = List.from(checked)


                ),
            Divider(),
            RadioButtonGroup(
                labels: <String>[
                  "Deliver to home",
                  "Deliver to work",
                ],
                onSelected: (String selected) => delivery=selected,

            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('Price : $price RO',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5,top: 20),
              child: Text('Rate our Services'),
            ),
            RatingBar(
              initialRating: 1,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) =>
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
              onRatingUpdate: (rating) {
                this.rating = rating.toString();
              },
            ),
            Padding(
                padding: EdgeInsets.only(top: 20,bottom: 20),
                child:RaisedButton(onPressed: () => Buy(context),
                  child: Text('Add To Favourites',style: TextStyle(fontSize: 24,fontWeight: FontWeight.w400),),
                  shape:RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.teal)
                  ),
                  padding: EdgeInsets.symmetric(vertical: 9.0,horizontal: 40.0),
                  color: Colors.teal,
                )
            ),



          ],
        ),
      ),
    );
  }
}
