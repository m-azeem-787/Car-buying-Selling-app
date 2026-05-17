
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_22/models/car.dart';
import 'package:flutter_application_22/models/nav.dart';
import 'package:flutter_application_22/screens/details.dart';
import 'package:flutter_application_22/screens/image.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Car>> fetchCars() async {
    final snapshot = await FirebaseFirestore.instance.collection('cars').get();
    return snapshot.docs.map((doc) {
      return Car.fromMap(doc.data(), doc.id);
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    timeDilation = 3;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset("assets/logo.png",width: 50,height: 50,),
                Text(" Wheel Deal",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),)
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20)
          )
        ),
        actions: [
          IconButton(
            onPressed: (){
              context.push("/addcar");
              }, 
            icon: Icon(Icons.library_add_rounded,color: Colors.amber,),
            tooltip: "Add Car"
            )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70), 
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 50,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.circular(30)
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                ) ,
              ),
            ),  
          )),
      ),

      bottomNavigationBar: CustomNavBar(currentIndex: 0),
        
      body: FutureBuilder<List<Car>>(
        future: fetchCars(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('❌ Error loading cars'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('🚗 No cars found'));
          }

          final cars = snapshot.data!;
          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final carinfo = cars[index];
              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.teal[50],
                          borderRadius: BorderRadius.circular(10)
                        ),

                        child: Hero(
                          tag: carinfo.image,
                          child: Image.network(carinfo.image,height: 250,width: double.infinity,))
                        ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("${carinfo.year}",)
                        ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text("${carinfo.make} ${carinfo.model}", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold), ),
                          Spacer(),
                          Text("PKR.${carinfo.price}" , style: TextStyle(fontSize: 20),)
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: (){
                              Navigator.push(context, 
                              MaterialPageRoute(builder: (context)=> ImageScreen(img: cars[index]))
                              );
                            }, 
                            child: Row(
                              children: [
                                Icon(Icons.remove_red_eye),
                                Text(" View")
                              ],)
                            ),
                          Spacer(),
                          ElevatedButton(
                            onPressed: (){
                              Navigator.push(context, 
                              MaterialPageRoute(builder: (context)=>DetailScreen(info: cars[index])
                              ));
                            }, 
                            child: Row(
                              children: [
                                Icon(Icons.car_crash),
                                Text(" Details")
                              ],)
                            ),
                        ],
                      )

                    ],
                  ),
                )
              );
            },
          );
        },
      ),

      
    );
  }
}