import 'package:flutter/material.dart';
import 'package:product_firestore_app/model/product_model.dart';
import 'package:product_firestore_app/service/database.dart';

// ignore: must_be_immutable
class ProductForm extends StatefulWidget {
  final ProductModel? product;
  const ProductForm({super.key, this.product});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {

  Database db = Database.myInstance;
  var nameController = TextEditingController();
  var priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.product != null){
      nameController.text = widget.product!.productName;
      priceController.text = widget.product!.price.toString();//Price เป็น double เลยต้องเติม toString
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    priceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.product != null ;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(isEditing ?'แก้ไขสินค้า ${widget.product!.productName}' : 'เพิ่มสินค้า' ), //ถ้าไม่มีสินค้าในฐานข้อมูลให้ขึ้น เพิ่ม เเต่ถ้ามีให้ขึ้นแก้ไข
        TextField(
          controller: nameController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(labelText: 'ชื่อสินค้า'),
        ),
        TextField(
          controller: priceController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(labelText: 'ราคาสินค้า'),
        ),
        const SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            showBtnOk(context,isEditing),
            const SizedBox(width: 10,),
            showBtnCencel(context)
          ],
        )
      ],
    );
  }

  Widget showBtnOk(BuildContext context, bool isEditing){
    return ElevatedButton(
      onPressed: () async{
        String newId = isEditing ? widget.product!.id : 'PD${DateTime.now().microsecondsSinceEpoch.toString()}';
        ProductModel product = ProductModel(
          id: newId, 
          productName: nameController.text, 
          price: double.tryParse(priceController.text)??0);
        await db.setProduct(product: product);
        nameController.clear();
        priceController.clear();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        myAlert(context);
      }, 
      child: Text(isEditing ? 'บันทึก' : 'เพิ่ม')
    );
  }

  Widget showBtnCencel(BuildContext context){
    return ElevatedButton(
      onPressed: (){
        Navigator.of(context).pop();
      }, 
      child: const Text('ปิด')
    );
  }

  void myAlert(BuildContext ctx){
    showDialog(
      context: ctx,
      builder: (ctx) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(), 
            child: const Text("Ok"))
        ],
        content: Text('บันทึกข้อมูลเรียบร้อย!!!'),
      )
    );
  }
}