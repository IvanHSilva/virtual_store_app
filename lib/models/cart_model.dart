import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/datas/cart_product.dart';
import 'package:virtual_store/models/user_model.dart';

class CartModel extends Model{

  UserModel user;
  List<CartProduct> products = [];
  bool isLoading = false;
  CartModel(this.user){
    if(user.isLoggedIn())
    _loadCartItems();
  }

  static CartModel of(BuildContext context) =>
    ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProd){
    
    products.add(cartProd);
    Firestore.instance.collection('users').document(user.fbUser.uid)
      .collection('cart').add(cartProd.toMap()).then((doc){
        cartProd.cid = doc.documentID;
      });
      notifyListeners();
  }
  
  void removeCartItem(CartProduct cartProd){
    Firestore.instance.collection('users').document(user.fbUser.uid)
      .collection('cart').document(cartProd.cid).delete();
    products.remove(cartProd);
    notifyListeners();
  }

  void removProd(CartProduct cartProd){
    cartProd.quantity--;
    Firestore.instance.collection('users').document(user.fbUser.uid).collection('cart')
    .document(cartProd.cid).updateData(cartProd.toMap());
    notifyListeners();
  }

  void adicProd(CartProduct cartProd){
    cartProd.quantity++;
    Firestore.instance.collection('users').document(user.fbUser.uid).collection('cart')
    .document(cartProd.cid).updateData(cartProd.toMap());
    notifyListeners();
  }

  void _loadCartItems() async{
    QuerySnapshot query = await Firestore.instance.collection('users').document(user.fbUser.uid)
    .collection('cart').getDocuments();
    products = query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();
    notifyListeners();
  }
}