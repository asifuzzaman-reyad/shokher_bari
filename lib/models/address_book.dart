class AddressBook {
  final String name;
  final String phone;
  final String region;
  final String city;
  final String area;
  final String address;

  AddressBook({
    required this.name,
    required this.phone,
    required this.region,
    required this.city,
    required this.area,
    required this.address,
  });

  // upload
  Map<String, Object> toJson() {
    return {
      'name': name,
      'phone': phone,
      'region': region,
      'city': city,
      'area': area,
      'address': address
    };
  }

  //fetch
  AddressBook.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          phone: json['phone']! as String,
          region: json['region']! as String,
          city: json['city']! as String,
          area: json['area']! as String,
          address: json['address']! as String,
        );
}
