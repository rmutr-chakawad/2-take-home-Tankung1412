import 'package:flutter/material.dart';
import 'package:product_firestore_app/model/product_model.dart';
import 'package:product_firestore_app/service/database.dart';
import 'package:product_firestore_app/widget/product_form.dart';
import 'package:product_firestore_app/widget/product_item.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    Database db = Database.myInstance;
    Stream<List<ProductModel>> myStream = db.getAllProductStream();

    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder<List<ProductModel>>( 
        stream: myStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('ยังไม่มีข้อมูลสินค้า'));
          }

          List<ProductModel> products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Dismissible(
                    key: ValueKey(products[index].id),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        db.deleteProduct(product: products[index]);
                        myAlert(context);
                      }
                    },
                    direction: DismissDirection.endToStart,
                    background: Container(color: Colors.red),
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return ProductForm(product: products[index]);
                          },
                        );
                      },
                      child: ProductItem(product: products[index]),
                    ),
                  ),
                  Divider(
                      color: Colors.blueGrey,
                      indent: 20,
                      endIndent: 20,
                      height: 1,)
                ],
              );
            },
          );
        },
      ),
    );
  }

  void myAlert(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (ctx) => AlertDialog(
        content: const Text('ลบข้อมูลเรียบร้อย!!!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }
}
