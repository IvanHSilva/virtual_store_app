import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_store/datas/product_data.dart';

class CartProduct { 
  
  String cid;
  String category;
  String pid;
  int quantity;
  String size;

  ProductData productData;
  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot doc){
    cid = doc.documentID;
    category = doc.data['category'];
    pid = doc.data['pid'];
    quantity = doc.data['quantity'];
    size = doc.data['size'];
  }

  Map<String, dynamic> toMap(){
    return {
      'category': category,
      'pid': pid,
      'quantity': quantity,
      'size': size,
      'product': productData.toResumedMap(),
    };
  }

}