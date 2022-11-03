import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firease7_8/screens/create&update_screen.dart';
import 'package:firease7_8/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:developer' as dev;

import 'package:flutter_slidable/flutter_slidable.dart';

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
                      var temp = snapshot.data!.docs[index];
                      return InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateAndUpdateScreen(
                                    coinMap: temp, docId: temp.id),
                              )),
                          child: Slidable(
                            key: const ValueKey(0),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              //  dismissible: DismissiblePane(onDismissed: () {}),
                              children: [
                                SlidableAction(
                                  onPressed: (context) async {
                                    await FirebaseFirestore.instance
                                        .collection('Coins')
                                        .doc(temp.id)
                                        .delete();
                                  },
                                  backgroundColor: Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(temp['logo']),
                                ),
                                title: Text(temp['name']),
                                trailing: Text('${temp['price']}\$'),
                              ),
                            ),
                          ));
                    },
                  );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CreateAndUpdateScreen(coinMap: null, docId: ''),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
