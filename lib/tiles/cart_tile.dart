import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/datas/cart_product.dart';
import 'package:virtual_store/datas/product_data.dart';
import 'package:virtual_store/models/cart_model.dart';

class CartTile extends StatelessWidget {

  final CartProduct cartProd;
  CartTile(this.cartProd);

  @override
  Widget build(BuildContext context) {

    Widget _buildContent(){
      return Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
              cartProd.productData.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                /*crossAxisAlignment: CrossAxisAlignment.start,*/
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    cartProd.productData.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    'Tamanho ${cartProd.size}',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 17.0,
                    ),
                  ),
                  Text(
                    'R\$ ${cartProd.productData.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove), 
                        color: Theme.of(context).primaryColor,
                        onPressed: cartProd.quantity > 1 ?
                        (){
                          CartModel.of(context).removProd(cartProd);
                        } : null,
                      ),
                      Text(cartProd.quantity.toString()),
                      IconButton(
                        icon: Icon(Icons.add), 
                        color: Theme.of(context).primaryColor,
                        onPressed: (){
                          CartModel.of(context).adicProd(cartProd);
                        }
                      ),
                      FlatButton(
                        child: Text('Remover'),
                        textColor: Colors.grey[500],
                        onPressed: (){
                          CartModel.of(context).removeCartItem(cartProd);
                        }, 
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: cartProd.productData == null ?
        FutureBuilder<DocumentSnapshot>(
          future: Firestore.instance.collection('products').document(cartProd.category)
          .collection('items').document(cartProd.pid).get(),
          builder:(context, snapshot){
            if(snapshot.hasData){
              cartProd.productData = ProductData.fromDocument(snapshot.data);
              return _buildContent();
            } else {
              return Container(
                height: 70.0,
                child: CircularProgressIndicator(),
                alignment: Alignment.center,
              );
            }
          },
        ) :
          _buildContent(),
    );
  }
}