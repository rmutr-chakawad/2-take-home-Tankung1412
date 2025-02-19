import 'package:flutter/material.dart';
import 'package:product_firestore_app/model/product_model.dart';
import 'package:product_firestore_app/widget/product_popup.dart';

// ignore: must_be_immutable
class ProductItem extends StatelessWidget {
  final ProductModel product;
  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context, 
          builder: (context){
            return ProductPopup(product: product);
          }
        );
      },
      child: ListTile(
        leading: Text(product.productName,style: TextStyle(fontSize: 14),),
        title: Text(product.price.toStringAsFixed(2), textAlign: TextAlign.right,),
        trailing: const Icon(Icons.chevron_right),

      )
    );
  }
}