import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class UpdateScreen extends StatefulWidget {
  UpdateScreen({super.key, required this.coinMap, required this.docId});
  Map<String, dynamic> coinMap;
  String docId;
  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController linkImageController = TextEditingController();
  String urImage = '';

  setDataState() {
    setState(() {
      nameController.text = widget.coinMap['name'];
      priceController.text = widget.coinMap['price'].toString();
      linkImageController.text = urImage = widget.coinMap['logo'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setDataState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: priceController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter price'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: linkImageController,
              onChanged: (value) {
                setState(() {
                  urImage = value;
                });
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter url image'),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: urImage.isEmpty
                        ? const NetworkImage(
                            'https://imgs.search.brave.com/buEi8LsoGrZYtlMnuD-lQ9swSJJQUNraKRP_DzEXSEw/rs:fit:1000:667:1/g:ce/aHR0cHM6Ly9kZWhh/eWY1bWh3MWg3LmNs/b3VkZnJvbnQubmV0/L3dwLWNvbnRlbnQv/dXBsb2Fkcy9zaXRl/cy8xMTQvMjAxNi8x/Mi8yMDA5MDgzMS9l/bXB0eS1ib3gtc2h1/dHRlcnN0b2NrLmpw/Zw')
                        : NetworkImage(urImage))),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await addDataToFireStore(
              id: DateTime.now().microsecond.toString(),
              name: nameController.text,
              price: priceController.text,
              logo: urImage);
        },
        child: const Icon(Icons.done),
      ),
    );
  }

  Future addDataToFireStore(
      {String? id, String? name, String? price, String? logo}) async {
    Map<String, dynamic> mapData = {
      'id': id,
      'name': name,
      'price': double.parse(price.toString()),
      'logo': logo,
    };
    await FirebaseFirestore.instance
        .collection('Coins')
        .doc(widget.docId.toString())
        .set(mapData)
        .then((value) => Navigator.pop(context));
  }
}
