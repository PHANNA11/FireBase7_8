import 'package:firease7_8/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
    );
  }
}
