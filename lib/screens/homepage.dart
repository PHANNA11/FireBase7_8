import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firease7_8/screens/create_data_screen.dart';
import 'package:firease7_8/screens/login_screen.dart';
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
  CollectionReference dataCoin = FirebaseFirestore.instance.collection('Coins');

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
      body: StreamBuilder(
        stream: dataCoin.snapshots(),
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
            return const CircularProgressIndicator();
          } else {
            final data = snapshot.data;
            return data == null
                ? const Center(
                    child: Text('No data...!!'),
                  )
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var snapData = snapshot.data!.docs[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateCoinScreen(
                                        docId: snapshot.data!.docs[index].id
                                            .toString(),
                                        coinMap: snapData,
                                      )));
                        },
                        child: Card(
                          elevation: 0,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage(snapData['logo'].toString()),
                            ),
                            title: Text(snapData['name'].toString()),
                            trailing: Text('${snapData['price']} \$'),
                          ),
                        ),
                      );
                    },
                  );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return CreateCoinScreen(
                coinMap: null,
                docId: '',
              );
            },
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
