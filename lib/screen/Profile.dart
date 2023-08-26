import 'package:carwash/constants.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('assets/car_wash.jpeg'), // Replace with user's profile image
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              // Implement logic to change profile image
            },
            child: Text('Change Profile Picture',style: TextStyle(color: Const.primaryColor2),),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Const.primaryColor2, // Set the background color to black
                      ),
                      onPressed: () {
                        // Implement save profile logic
                      },
                      child: Text('Save Profile'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
