import 'package:carwash/constants.dart';
import 'package:carwash/screen/Login.dart';
import 'package:carwash/viewmodel/IndexViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading=false;
  bool _passwordVisible = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String selectedRole = Role.manager;

  @override
  Widget build(BuildContext context) {
    IndexViewModel indexViewModel=Provider.of<IndexViewModel>(context);

    return Scaffold(
      appBar: Const.appbar('Create your account'),
      body: SizedBox(
        height: Const.hi(context),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  Const.logo,
                  width: Const.wi(context) / 2,
                  height: Const.wi(context) / 2,
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),



                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      obscureText: _passwordVisible,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          child: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                        ),
                      ),
                    ),
                  ),


                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),




                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Select Role :',style: TextStyle(fontWeight: FontWeight.bold),),

                        RadioListTile<String>(
                          title: const Text('Manager'),
                          value: Role.manager,
                          groupValue: selectedRole,
                          onChanged: (value) {
                            setState(() {
                              selectedRole = value!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Technician'),
                          value: Role.technician,
                          groupValue: selectedRole,
                          onChanged: (value) {
                            setState(() {
                              selectedRole = value!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Customer'),
                          value: Role.customer,
                          groupValue: selectedRole,
                          onChanged: (value) {
                            setState(() {
                              selectedRole = value!;
                            });
                          },
                        ),

                        const Divider(),

                      ],
                    ),
                  ),



                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Const.primaryColor, minimumSize: Size((MediaQuery.of(context).size.width / 3), 60),
                      textStyle: const TextStyle(
                          color: Colors.black, fontSize: 22),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(_loading ? 'Processing..' :'Register'),
                    onPressed: () async{
                      if (_nameController.text.isEmpty) {
                        Const.toastMessage('Name is required.');
                      } else if (_emailController.text.isEmpty) {
                        Const.toastMessage('Email is required.');
                      } else if (_phoneController.text.isEmpty) {
                        Const.toastMessage('Phone is required.');
                      } else if (_passwordController.text.isEmpty) {
                        Const.toastMessage('Password is required.');
                      } else {
                        Map<String,dynamic> data = {
                          'name': _nameController.text,
                          'email': _emailController.text,
                          'phone': _phoneController.text,
                          'password': _passwordController.text,
                          'address': _addressController.text,
                          'role': selectedRole.toString(),
                        };
                        if(!_loading){
                          try{
                            setState(() { _loading=true; });
                            await indexViewModel.registerApi(data);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                          }catch(e){
                            print(e);
                          }
                          setState(() { _loading=false; });
                        }

                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: () {
                // Navigate to registration page
                // For example:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child: Text("Already have an account. Login here",style: TextStyle(color: Const.primaryColor),),
            ),
          ],
        ),
      ),
    );
  }
}
