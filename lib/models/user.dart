class AppUser{
  final String uid;
  final String name;
  final String email;
  final String facebook;
  final String instagram;
  final String number;

  AppUser({
    required this.uid,
    required this.name, 
    required this.email, 
    required this.facebook, 
    required this.instagram, 
    required this.number
    });

  factory AppUser.fromMap(Map<String,dynamic>data,String id){
    return AppUser(
      uid: id,
      name: data['name'], 
      email: data['email'] ?? "", 
      facebook: data['facebook'] ?? '', 
      instagram: data['instagram'] ?? '', 
      number: data['number']
      );
  }
}