import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/datas/cart_product.dart';
import 'package:virtual_store/models/cart_model.dart';

class CartPrice extends StatelessWidget {

  final VoidCallback buy;
  CartPrice(this.buy);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: ScopedModelDescendant <CartModel>(
          builder: (context, child, model){

            double price = model.getProductPrice();
            double discount = model.getDiscount();
            double ship = model.getShipPrice();
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Resumo do Pedido',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 12.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Subtotal', style: TextStyle(fontSize: 18.0),),
                    Text('R\$ ${price.toStringAsFixed(2)}', style: TextStyle(fontSize: 16.0),),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Desconto', style: TextStyle(fontSize: 18.0),),
                    Text('R\$ ${discount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16.0),),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Entrega', style: TextStyle(fontSize: 18.0),),
                    Text('R\$ ${ship.toStringAsFixed(2)}', style: TextStyle(fontSize: 16.0),),
                  ],
                ),
                Divider(),
                SizedBox(height: 12.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Total', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,),),
                    Text('R\$ ${(price + ship - discount).toStringAsFixed(2)}', style: TextStyle(fontSize: 20.0, color: Theme.of(context).primaryColor),),
                  ],
                ),
                SizedBox(height: 12.0,),
                RaisedButton(
                  child: Text('Finalizar Pedido'),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onPressed: buy,
                ),
              ],
            );
          },
        ),
     ),
    );
  }
}