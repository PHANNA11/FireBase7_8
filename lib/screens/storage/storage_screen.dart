import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:developer' as dev;

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
      ),
      body: Center(
        child: retrievFile == null ? SizedBox() : Image.network(retrievFile),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            getFileStorage('unnamed-14');
          });
        },
        child: const Icon(Icons.download),
      ),
    );
  }

  var retrievFile;

  Future<String?> getFileStorage(String? imageName) async {
    if (imageName == null) {
      return '';
    }
    try {
      var urlRef = firestorage.child('$imageName.png');
      var imageUrl = await urlRef.getDownloadURL();
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
}
