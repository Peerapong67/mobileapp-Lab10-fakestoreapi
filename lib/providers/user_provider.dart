import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  List<UserModel> _users = [];
  bool _isLoading = false;

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    final response = await http.get(Uri.parse('https://fakestoreapi.com/users'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      _users = data.map((item) => UserModel.fromJson(item)).toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> deleteUser(int id) async {
    final response = await http.delete(
      Uri.parse('https://fakestoreapi.com/users/$id'),
    );

    if (response.statusCode == 200) {
      _users.removeWhere((u) => u.id == id);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> updateUser(int id, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('https://fakestoreapi.com/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      // อัปเดต local list ทันที
      final index = _users.indexWhere((u) => u.id == id);
      if (index != -1) {
        final updated = json.decode(response.body);
        _users[index] = UserModel.fromJson({
          'id': id,
          'email': updated['email'] ?? _users[index].email,
          'username': updated['username'] ?? _users[index].username,
          'password': updated['password'] ?? _users[index].password,
          'name': updated['name'] ?? {'firstname': _users[index].name.firstname, 'lastname': _users[index].name.lastname},
          'address': updated['address'] ?? {
            'city': _users[index].address.city,
            'street': _users[index].address.street,
            'number': _users[index].address.number,
            'zipcode': _users[index].address.zipcode,
          },
          'phone': updated['phone'] ?? _users[index].phone,
        });
        notifyListeners();
      }
      return true;
    }
    return false;
  }
}
