
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddCarScreen extends StatefulWidget {
  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _make = TextEditingController();
  final _model = TextEditingController();
  final _year = TextEditingController();
  final _price = TextEditingController();
  final _description = TextEditingController();
  final _image = TextEditingController();

  Future<void> _addCar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('cars').add({
      'ownerUID': user.uid,
      'make': _make.text.trim(),
      'model': _model.text.trim(),
      'year': int.tryParse(_year.text.trim()) ?? 0,
      'price': double.tryParse(_price.text.trim()) ?? 0.0,
      'description': _description.text.trim(),
      'image' : _image.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Car added for sale!')));
    _make.clear();
    _model.clear();
    _year.clear();
    _price.clear();
    _description.clear();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.amber[50],
        appBar: AppBar(
          iconTheme:IconThemeData(color: Colors.white),
          title: Text("Add Car",style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.grey[800],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(child: Text("All fields are required",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),)),
                TextField(controller: _image, decoration: InputDecoration(labelText: "ImageURL")),
                TextField(controller: _make, decoration: InputDecoration(labelText: "Make")),
                TextField(controller: _model, decoration: InputDecoration(labelText: "Model")),
                TextField(controller: _year, decoration: InputDecoration(labelText: "Year")),
                TextField(controller: _price, decoration: InputDecoration(labelText: "Price")),
                TextField(controller: _description, decoration: InputDecoration(labelText: "Description")),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    fixedSize: Size(200, 30)
                    ),
                  onPressed: _addCar, 
                  child: Text("Add Car",style: TextStyle(color: Colors.white),)
                  ),
                  SizedBox(height: 10,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    fixedSize: Size(100, 30)
                    ),
                  onPressed: (){
                  context.pop();
                }, child: Text("Cancel",style: TextStyle(color: Colors.white))
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
