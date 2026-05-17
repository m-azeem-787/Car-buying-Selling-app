class Car{
  final String id;
  final String ownerUID;
  final String make;
  final String model;
  final int year;
  final double price;
  final String description;
  final String image;

  Car({
    required this.id, 
    required this.ownerUID, 
    required this.make, 
    required this.model, 
    required this.year, 
    required this.price, 
    required this.description,
    required this.image
    });

  factory Car.fromMap(Map<String,dynamic> data,String docId){
    return Car(
      id: docId, 
      ownerUID: data['ownerUID'] ?? '', 
      make: data['make'], 
      model: data['model'], 
      year: data['year'], 
      price: (data['price'] ?? 0).toDouble(),
      description: data['description'] ?? '', 
      image: data['image']
      );
  }
}