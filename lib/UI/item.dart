import 'package:cloud_firestore/cloud_firestore.dart';


class Item{
  String resturantName;
  String foodName;
  String location;
  String price;
  String photo;

  DocumentReference documentReference;

  Item({this.resturantName,this.foodName,this.location,this.price,this.photo});

  Item.fromMap(Map<String,dynamic> map, {this.documentReference}){

     resturantName  = map["resturantName"];
     foodName = map["foodName"];
     location = map["location"];
     price = map["price"];
     photo = map["photo"];



    // print("Documents -> $bookName  $authorName");

  }

  Item.fromSnapshot(DocumentSnapshot snapshot)
      :this.fromMap(snapshot.data, documentReference:snapshot.reference);

  toJson(){
    return{'resturantName': resturantName, 'foodName' : foodName, 'location' : location, 'price' : price, 'photo' : photo};

  }

}