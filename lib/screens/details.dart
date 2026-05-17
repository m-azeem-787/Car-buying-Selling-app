import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_22/models/car.dart';
import 'package:flutter_application_22/models/user.dart';

List<String> bookedCarIds = [];

class DetailScreen extends StatefulWidget {
  final Car info;

  const DetailScreen({super.key, required this.info});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  AppUser? owner;

  @override
  void initState() {
    super.initState();
    fetchOwner();
  }

  Future<void> fetchOwner() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.info.ownerUID)
            .get();

    if (doc.exists) {
      setState(() {
        owner = AppUser.fromMap(doc.data()!, doc.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("Details"),
          centerTitle: true,
          backgroundColor: Colors.grey[900],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Hero(
                  tag: widget.info.image,
                  child: Image.network(widget.info.image, fit: BoxFit.contain),
                ),
                Text(
                  "${widget.info.make} ${widget.info.model}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                Text(
                  "Year: ${widget.info.year}",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  "Price: PKR. ${widget.info.price}",
                  style: TextStyle(fontSize: 20),
                ),
                Divider(),
                Text(
                  "Description",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                Text(widget.info.description, style: TextStyle(fontSize: 20)),
                Divider(),
                Text(
                  "Contact info",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                Text("Name: ${owner?.name ?? 'Loading..'}"),
                Text("Email: ${owner?.email ?? 'Loading..'}"),
                Text("Contact: ${owner?.number ?? 'Loading..'}"),
                Text("Facebook: ${owner?.facebook ?? 'NA'}"),
                Text("Instagram: ${owner?.instagram ?? 'NA'}"),
                Divider(thickness: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreenAccent,
                      ),
                      onPressed: () {
                        if (!bookedCarIds.contains(widget.info.id)) {
                          bookedCarIds.add(widget.info.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Car Booked!')),
                          );
                        }
                        
                      },
                      child: Text(
                        "Book",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrangeAccent,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Request forwarded!")),
                        );
                      },
                      child: Text(
                        "Request Inspection",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
