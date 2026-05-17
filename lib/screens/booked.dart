import 'package:flutter/material.dart';
import 'package:flutter_application_22/models/car.dart';
import 'package:flutter_application_22/screens/details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookedScreen extends StatefulWidget {
  const BookedScreen({super.key});
  @override
  State<BookedScreen> createState() => _BookedScreenState();
}
class _BookedScreenState extends State<BookedScreen> {
  Future<List<Car>> fetchBookedCars() async {
    final snapshot = await FirebaseFirestore.instance.collection('cars').get();
    return snapshot.docs
        .where((doc) => bookedCarIds.contains(doc.id))
        .map((doc) => Car.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Cars Booked", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Car>>(
        future: fetchBookedCars(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final cars = snapshot.data ?? [];
          if (cars.isEmpty) {
            return const Center(child: Text("No booked cars yet."));
          }

          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];
              return ListTile(
                leading: Image.network(car.image, width: 60, height: 60, fit: BoxFit.cover),
                title: Text('${car.make} ${car.model}'),
                subtitle: Text('PKR ${car.price}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailScreen(info: car)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
