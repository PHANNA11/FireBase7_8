import 'package:firease7_8/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _getInitFirebase,
    );
  }
}

// class MainPoinPage extends StatelessWidget {
//   const MainPoinPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<User?>(
//           stream: FirebaseAuth.instance.authStateChanges(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return const HomePage();
//             } else {
//               return const LoginScreen();
//             }
//           }),
//     );
//   }
// }

get _getInitFirebase {
  return FutureBuilder(
    future: Firebase.initializeApp(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const Scaffold(
          body: Center(
            child: Icon(
              Icons.info,
              size: 35,
              color: Colors.red,
            ),
          ),
        );
      }
      if (snapshot.connectionState == ConnectionState.done) {
        return const LoginScreen();
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.greenAccent,
//       body: SafeArea(
//         child: Column(
//           children: [
//             const Expanded(
//               flex: 2,
//               child: Center(
//                 child: Text(
//                   'Flutter Authentication',
//                   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: MaterialButton(
//                 height: 50,
//                 color: Colors.white,
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const LoginScreen(),
//                       ));
//                 },
//                 child: const Center(
//                     child: Text('login',
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold))),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: MaterialButton(
//                 height: 50,
//                 color: Colors.white,
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => RegisterAccountScreen(),
//                       ));
//                 },
//                 child: const Center(
//                     child: Text('Register now',
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold))),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
