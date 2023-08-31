import 'package:carwash/constants.dart';
import 'package:carwash/viewmodel/IndexViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();


  int? authId;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authId=ShPref.getAuthId();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    IndexViewModel _indexViewModel=Provider.of<IndexViewModel>(context);
    nameController.text=_indexViewModel.getUser!.name!;
    emailController.text=_indexViewModel.getUser!.email!;
    phoneController.text=_indexViewModel.getUser!.phone!;
    addressController.text=_indexViewModel.getUser!.address!;
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
            child: /*Text('Change Profile Picture',style: TextStyle(color: Const.primaryColor),)*/ Container(),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                TextField(
                  controller:nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                SizedBox(height: 16),
                TextField(
                  enabled: false,
                  controller:emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller:phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller:addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Const.primaryColor, // Set the background color to black
                      ),
                      onPressed: ()async {
                        if (nameController.text.isEmpty) {
                          Const.toastMessage('Name is required.');
                        } else if (phoneController.text.isEmpty) {
                          Const.toastMessage('Phone is required.');
                        } else if (addressController.text.isEmpty) {
                          Const.toastMessage('Address is required.');
                        } else {
                          Map<String, dynamic> data = {
                            'id':authId,
                            'name': nameController.text,
                            'phone': phoneController.text,
                            'address': addressController.text,
                          };
                          Map response=await _indexViewModel.editUser(data);

                          print(response);
                        }
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
