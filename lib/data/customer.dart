class Customer {
  final String id;
  final String cid;
  final String name;
  final DateTime dob;
  final String address;
  final String email;
  final String phone;
  final String pass;

  Customer({
    required this.id,
    required this.cid,
    required this.name,
    required this.dob,
    required this.address,
    required this.email,
    required this.phone,
    required this.pass,
  });




  factory Customer.fromJson(Map<String, dynamic> data) {
    return Customer(
        id: data['id'] ?? '',
        cid: data['cid'] ?? '',
        name: data['name'] ?? '',
        dob: DateTime.fromMillisecondsSinceEpoch(data['dateOfBirth']["_seconds"] * 1000),
        address: data['address'] ?? '',
        email: data['email'] ?? '',
        phone:data['phoneNumber'] ?? '',
        pass: data['password'] ?? ''
    );
  }


}
