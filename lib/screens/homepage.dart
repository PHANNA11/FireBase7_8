import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firease7_8/screens/login_screen.dart';
import 'package:firease7_8/screens/page_create.dart';
import 'package:firease7_8/screens/update_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:developer' as dev;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> docIDs = [];
  Future getDataFromFireStore() async {
    await FirebaseFirestore.instance.collection('Coins').get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          docIDs.add(element.reference.id);
        });
      });
    });
  }

  Future getCoin(String docId) async {
    final coins = FirebaseFirestore.instance.collection('Coins').doc(docId);

    final snapshot = await coins.get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      dev.log(data.toString());
    }
  }

  var fielList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fielList = getDataFromFireStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: Column(
        children: [
          Container(
            height: 200,
            color: Theme.of(context).primaryColor,
          ),
          InkWell(
            onTap: () async {
              await FirebaseAuth.instance
                  .signOut()
                  .then((value) => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false));
            },
            child: const ListTile(
              leading: Icon(Icons.person),
              title: Text('Log Out'),
              trailing: Icon(Icons.logout),
            ),
          )
        ],
      )),
      appBar: AppBar(title: const Text('HomePage')),
      body: ListView.builder(
        itemCount: docIDs.length,
        itemBuilder: (context, index) {
          CollectionReference dataCoin =
              FirebaseFirestore.instance.collection('Coins');
          return FutureBuilder<DocumentSnapshot>(
            future: dataCoin.doc(docIDs[index]).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Icon(
                    Icons.info,
                    color: Colors.red,
                    size: 50,
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                final data = snapshot.data;
                return data == null
                    ? const Center(
                        child: Text('No data...!!'),
                      )
                    : InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateScreen(
                                  coinMap: data.data() as Map<String, dynamic>,
                                  docId: docIDs[index]),
                            ),
                          );
                        },
                        onLongPress: () async {
                          await FirebaseFirestore.instance
                              .collection('Coins')
                              .doc(docIDs[index])
                              .delete()
                              .then((value) {
                            setState(() {
                              fielList = getDataFromFireStore();
                              dev.log('message delete success');
                            });
                          });
                        },
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(data['logo'].toString()),
                            ),
                            title: Text(data['name'].toString()),
                            trailing: Text('${data['price']}\$'),
                          ),
                        ),
                      );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return CreateCoinScreen();
            },
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
