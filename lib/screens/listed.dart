import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_22/models/car.dart';
import 'package:flutter_application_22/screens/details.dart';
import 'package:go_router/go_router.dart';

class ListedScreen extends StatefulWidget {
  const ListedScreen({super.key});

  @override
  State<ListedScreen> createState() => _ListedScreenState();
}

class _ListedScreenState extends State<ListedScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Stream<List<Car>> getUserListedCars() {
    return FirebaseFirestore.instance
        .collection('cars')
        .where('ownerUID', isEqualTo: uid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Car.fromMap(doc.data(), doc.id)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Listed Cars", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<List<Car>>(
        stream: getUserListedCars(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final cars = snapshot.data ?? [];

          if (cars.isEmpty) {
            return const Center(child: Text("No listed cars found."));
          }

          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];
              return ListTile(
                leading: Image.network(car.image, width: 60, height: 60, fit: BoxFit.cover),
                title: Text("${car.make} ${car.model} (${car.year})"),
                subtitle: Text("PKR ${car.price.toStringAsFixed(0)}"),
                onTap: () {
                  Navigator.push(context, 
                              MaterialPageRoute(builder: (context)=>DetailScreen(info: car,)
                              ));
                }
              );
            },
          );
        },
      ),
    );
  }
}
