import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/datas/cart_product.dart';
import 'package:virtual_store/models/user_model.dart';

class CartModel extends Model{

  UserModel user;
  List<CartProduct> products = [];

  String couponCode;
  int discountPercentage = 0;

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

  void setCoupon(String couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void updatePrices(){
    notifyListeners();
  }

  double getProductPrice(){
    double price = 0.0;
    for(CartProduct c in products){
      if(c.productData != null){
        price += c.quantity * c.productData.price;
      }
    }
    return price;
  }

  double getDiscount(){
    return getProductPrice() * discountPercentage / 100;
  }

  double getShipPrice(){
    return 15.99;
  }

  Future<String> finishOrder() async {
    
    if (products.length == 0) return null;
    isLoading = true;
    notifyListeners();

    double prodPrice = getProductPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder = await Firestore.instance.collection('orders').add(
      {
        'clientId': user.fbUser.uid,
        'products': products.map((CartProduct) => CartProduct.toMap()).toList(),
        'shipPrice': shipPrice,
        'prodPrice': prodPrice,
        'discount': discount,
        'totalPrice': prodPrice - discount + shipPrice,
        'status': 1
      }
    );
    await Firestore.instance.collection('users').document(user.fbUser.uid).collection('orders')
    .document(refOrder.documentID).setData(
      {
        'orderId': refOrder.documentID
      }
    );

    QuerySnapshot query = await Firestore.instance.collection('users').document(user.fbUser.uid)
    .collection('cart').getDocuments();
    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }

    products.clear();
    couponCode = null;
    discountPercentage = 0;
    isLoading = false;
    notifyListeners();

    return refOrder.documentID;
  }

  void _loadCartItems() async{
    QuerySnapshot query = await Firestore.instance.collection('users').document(user.fbUser.uid)
    .collection('cart').getDocuments();
    products = query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();
    notifyListeners();
  }
}