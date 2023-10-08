import 'package:carwash/constants.dart';
import 'package:carwash/viewmodel/IndexViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {


  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _loading=false;

  bool _currentPasswordVisible = true;
  bool _newPasswordVisible = true;
  bool _confirmPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    IndexViewModel indexViewModel=Provider.of<IndexViewModel>(context);

    return Scaffold(
      appBar: Const.appbar('Password Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Change Password',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: _currentPasswordVisible,
              controller: _currentPasswordController,
              decoration: InputDecoration(
                labelText: 'Current Password',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentPasswordVisible = !_currentPasswordVisible;
                    });
                  },
                  child: Icon(
                    _currentPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: _newPasswordVisible,
              controller: _newPasswordController,

              decoration: InputDecoration(
                labelText: 'New Password',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _newPasswordVisible = !_newPasswordVisible;
                    });
                  },
                  child: Icon(
                    _newPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: _confirmPasswordVisible,
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _confirmPasswordVisible = !_confirmPasswordVisible;
                    });
                  },
                  child: Icon(
                    _confirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                    if(!_loading){
                      try{
                        setState(() { _loading=true; });
                        await indexViewModel.changePassword(data);
                        Navigator.pop(context);
                      }catch(e){ }
                      setState(() { _loading=false; });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Const.primaryColor, // Set background color to black
                ),
                child: Text(
                  _loading? 'Processing..':'Change Password',
                  style: const TextStyle(color: Colors.white),
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
  runApp(const MaterialApp(
    home: ChangePasswordPage(),
  ));
}
