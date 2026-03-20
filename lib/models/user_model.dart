class UserName {
  final String firstname;
  final String lastname;

  UserName({required this.firstname, required this.lastname});

  factory UserName.fromJson(Map<String, dynamic> json) {
    return UserName(
      firstname: json['firstname'],
      lastname: json['lastname'],
    );
  }
}

class UserAddress {
  final String city;
  final String street;
  final int number;
  final String zipcode;

  UserAddress({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      city: json['city'],
      street: json['street'],
      number: json['number'],
      zipcode: json['zipcode'],
    );
  }
}

class UserModel {
  final int id;
  final String email;
  final String username;
  final String password;
  final UserName name;
  final UserAddress address;
  final String phone;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
    required this.name,
    required this.address,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
      name: UserName.fromJson(json['name']),
      address: UserAddress.fromJson(json['address']),
      phone: json['phone'],
    );
  }
}
