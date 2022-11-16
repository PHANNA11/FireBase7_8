import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:developer' as dev;

import 'package:image_picker/image_picker.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  Reference get firestorage => FirebaseStorage.instance.ref();
  File? fileImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage'),
        actions: [
          IconButton(
              onPressed: () {
                getImageFromGallary();
              },
              icon: const Icon(Icons.image)),
          IconButton(
              onPressed: () async {
                uploadFile();
              },
              icon: const Icon(Icons.upload)),
          const SizedBox(height: 40),
        ],
      ),
      body: Column(
        children: [
          // Container(
          //   height: 300,
          //   width: double.infinity,
          //   color: Colors.red,
          // ),
          Center(
            child:
                retrievFile == null ? SizedBox() : Image.network(retrievFile),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var urlRef = firestorage.child('/File:`').child(
              '/data/user/0/com.example.firease7_8/cache/image_picker7162668884927892.png');
          var imageUrl = await urlRef.getDownloadURL();
          dev.log('Download:${imageUrl}');
          setState(() {
            retrievFile = imageUrl;
          });
        },
        child: const Icon(Icons.download),
      ),
    );
  }

  var retrievFile;
  Future uploadFile() async {
    late Reference ref;
    final path = "$fileImage";
    ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(fileImage!).then((p0) async {
      var t = await ref.child('/File:').child(fileImage!.path).getDownloadURL();
      dev.log('Download:${t.toString()}');
    });
  }

  Future<String?> getFileStorage(String? imageName) async {
    if (imageName == null) {
      dev.log('Empty file');
      return '';
    }
    try {
      //   dev.log('Download:$imageName');
      var urlRef = firestorage.child('/File:`').child(
          '/data/user/0/com.example.firease7_8/cache/image_picker7162668884927892.png');
      var imageUrl = await urlRef.getDownloadURL();
      dev.log('Download:${imageUrl}');
      setState(() {
        retrievFile = imageUrl;
      });

      print(imageUrl);
      return imageUrl;
    } catch (e) {
      print(e);
      return '';
    }
  }

  // ==================================
  getImageFromGallary() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      fileImage = File(file!.path);
    });
  }
}
