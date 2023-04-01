import 'package:amazon_clone/features/auth/services/auth_service.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  final AuthService authService = AuthService();

  UserProvider() {
    // print("###################################");
    // authService.getUserData(context);
  }
  User _user = User(
      id: '',
      name: '',
      email: '',
      password: '',
      address: '',
      type: '',
      cart: [],
      token: '');
  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    print('*********************');
    print(_user.toString());
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
