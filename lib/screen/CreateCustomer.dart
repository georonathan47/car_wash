import 'package:carwash/constants.dart';
import 'package:carwash/viewmodel/IndexViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AddCustomerPage extends StatefulWidget {
  const AddCustomerPage({super.key});

  @override
  _AddCustomerPageState createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();



  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    IndexViewModel indexViewModel=Provider.of<IndexViewModel>(context);


    return Scaffold(
      appBar: Const.appbar('Add Customer'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),


            const SizedBox(height: 20),
            const Center(
              child:CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/car_wash.jpeg'), // Replace with user's profile image
              ),
            ),


            const SizedBox(height: 16),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),



            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),

            const SizedBox(height: 20), // Add spacing between sections
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: ()async {
                    if (nameController.text.isEmpty) {
                      Const.toastMessage('Name is required.');
                    } else if (emailController.text.isEmpty) {
                      Const.toastMessage('Email is required.');
                    } else if (phoneController.text.isEmpty) {
                      Const.toastMessage('Phone is required.');
                    } else if (locationController.text.isEmpty) {
                      Const.toastMessage('Address is required.');
                    } else {
                      Map<String, dynamic> data = {
                        'name': nameController.text,
                        'password': 'JHBKJBJ#B',
                        'email': emailController.text,
                        'phone': phoneController.text,
                        'address': locationController.text,
                        'role': Role.customer,
                      };
                      await indexViewModel.registerApi(data);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Set background color to black
                  ),
                  child: const Text(
                    'Create Customer',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
