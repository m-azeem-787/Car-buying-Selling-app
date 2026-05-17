import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_22/screens/addcar.dart';
import 'package:flutter_application_22/screens/booked.dart';
import 'package:flutter_application_22/screens/home.dart';
import 'package:flutter_application_22/screens/image.dart';
import 'package:flutter_application_22/screens/listed.dart';
import 'package:flutter_application_22/screens/profile.dart';
import 'firebase_options.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/addcar', builder: (context, state) => AddCarScreen()),
    GoRoute(path: '/booked', builder: (context, state) => BookedScreen()),
    GoRoute(path: '/listed', builder: (context, state) => ListedScreen()),
    GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String message = '';

  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      setState(() => message = '✅ Login Successful!');
      context.go('/home');
    } catch (e) {
      setState(() => message = '❌ Error: $e');
    }
  }

  Future<void> signUp() async {
  try {
    
    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    final uid = userCredential.user!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': '',     
      'email': emailController.text.trim(),
      'number': '',
      'facebook': '',
      'instagram': '',
    });

    setState(() => message = '✅ Sign Up Successful! Now Login');
  } catch (e) {
    setState(() => message = '❌ Error: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade900, Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.grey[900],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/logo.png", width: 100, height: 100),
                const Text(" Wheel Deal", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 40)),
              ],
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Text("Login", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                  const Divider(),
                  TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      fixedSize: const Size(200, 40),
                    ),
                    child: const Text('Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                  ),
                  TextButton(onPressed: signUp, child: const Text('Sign Up')),
                  const SizedBox(height: 20),
                  Text(message, style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
