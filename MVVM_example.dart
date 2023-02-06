import 'package:flutter/material.dart';

//Model
class User {
  final String name;
  final int age;

  User({required this.name, required this.age});
}

//ViewModel
class UserViewModel {
  final User _user;

  UserViewModel({required User user}) : _user = user;

  String get name => _user.name;
  int get age => _user.age;
}

//View
class UserDetailPage extends StatelessWidget {
  final UserViewModel viewModel;

  const UserDetailPage({required Key key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              viewModel.name,
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              '${viewModel.age} years old',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
