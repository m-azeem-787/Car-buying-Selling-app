import 'package:flutter/material.dart';
import 'package:flutter_application_22/models/car.dart';

class ImageScreen extends StatelessWidget {
  final Car img;
  const ImageScreen({super.key, required this.img,});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Back"),
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Hero(
            tag: img.image,
            child: Image.network(img.image,fit: BoxFit.contain,)),
        ),
      )
      );
  }
}