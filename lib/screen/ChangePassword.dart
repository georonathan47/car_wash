import 'package:carwash/constants.dart';
import 'package:carwash/viewmodel/IndexViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {


  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  
  @override
  Widget build(BuildContext context) {
    IndexViewModel _indexViewModel=Provider.of<IndexViewModel>(context);

    return Scaffold(
      appBar: Const.appbar('Password Settings'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Change Password',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              obscureText: true,
              controller: _currentPasswordController,
              decoration: InputDecoration(
                labelText: 'Current Password',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              controller: _newPasswordController,

              decoration: InputDecoration(
                labelText: 'New Password',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              obscureText: true,
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: ()async {


                  if (_currentPasswordController.text.isEmpty) {
                    Const.toastMessage('Current password is required');
                  } else if (_newPasswordController.text.isEmpty) {
                    Const.toastMessage('New Password is required');
                  } else if (_confirmPasswordController.text.isEmpty) {
                    Const.toastMessage('Current Password is required');
                  } else if (_confirmPasswordController.text != _newPasswordController.text) {
                    Const.toastMessage('Confirm password does not match');
                  } else {
                    Map data = {
                      'current_password': _currentPasswordController.text,
                      'new_password': _newPasswordController.text,
                      'confirm_password': _confirmPasswordController.text,
                    };
                    await _indexViewModel.changePassword(data);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Const.primaryColor, // Set background color to black
                ),
                child: Text(
                  'Change Password',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ChangePasswordPage(),
  ));
}
