import 'package:flutter/material.dart';
import 'package:product_firestore_app/widget/product_list.dart';
import 'package:product_firestore_app/widget/product_popup.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        backgroundColor: Colors.blue.shade300,
        actions: [
          IconButton(
            onPressed: (){
              showModalBottomSheet(
                isScrollControlled: true,
                context: context, 
                builder: (context) => ProductPopup()
              );
            }, 
            icon: const Icon(Icons.add),color: Colors.white,)
        ],
      ),

      body: const ProductList(),
    );
  }
}