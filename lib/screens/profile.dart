import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_22/models/nav.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final insta = TextEditingController();
  final fb = TextEditingController();
  final nameController = TextEditingController();
  final numberController = TextEditingController();

  String email = '';

  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        nameController.text = data['name'] ?? '';
        email = data['email'] ?? '';
        numberController.text = data['number'] ?? '';
        insta.text = data['instagram'] ?? '';
        fb.text = data['facebook'] ?? '';
      });
    }
  }

  Future<void> saveUserData() async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': nameController.text.trim(),
      'number': numberController.text.trim(),
      'instagram': insta.text.trim(),
      'facebook': fb.text.trim(),
    }, SetOptions(merge: true));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Saved")));
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
          title: const Text("Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.grey[800],
        ),
        bottomNavigationBar: CustomNavBar(currentIndex: 1),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage("assets/pfp.png"),
                  radius: 60,
                ),
                const SizedBox(height: 10),
                Text("Email: $email", style: const TextStyle(color: Colors.white, fontSize: 18)),
                const Divider(color: Colors.white70, thickness: 1),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: numberController,
                  decoration: const InputDecoration(
                    labelText: "Contact Number",
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: insta,
                  decoration: const InputDecoration(
                    labelText: "Instagram (optional)",
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: fb,
                  decoration: const InputDecoration(
                    labelText: "Facebook (optional)",
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: saveUserData,
                  child: const Text("Save"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => context.push('/listed'),
                  child: Text("Listed Cars"),
                ),
                ElevatedButton(
                  onPressed: () => context.push('/booked'),
                  child: Text("Booked Cars"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
