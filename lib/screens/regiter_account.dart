import 'package:firease7_8/screens/homepage.dart';
import 'package:firease7_8/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class RegisterAccountScreen extends StatefulWidget {
  const RegisterAccountScreen({super.key});

  @override
  State<RegisterAccountScreen> createState() => _RegisterAccountScreenState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController cpasswordController = TextEditingController();

class _RegisterAccountScreenState extends State<RegisterAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 80, bottom: 40),
              child: Text(
                'Flutter Authentication',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('E-mail'),
                    hintText: 'Enter Email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('password'),
                    hintText: 'Enter password'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: cpasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Confirm-password'),
                    hintText: 'Enter Confirm-password'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: MaterialButton(
                height: 50,
                color: Colors.greenAccent,
                onPressed: () async {
                  try {
                    if (emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty &&
                        cpasswordController.text.isNotEmpty) {
                      if (passwordController.text != cpasswordController.text) {
                        print('Password not correct');
                      } else {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text)
                            .then((value) => Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (route) => false));
                        print('object was Create');
                      }
                    } else {
                      print('something was Empty..!!');
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                    }
                  }
                },
                child: const Center(
                  child: Text('Create',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const Divider(
              color: Colors.black,
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: MaterialButton(
                height: 50,
                color: Colors.greenAccent,
                onPressed: () {},
                child: const Center(
                  child: Text('Login With FackBook',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text('I have ready an account '),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false);
                  },
                  child: const Text('login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
