import 'package:carwash/constants.dart';
import 'package:carwash/model/User.dart';
import 'package:carwash/screen/Activites.dart';
import 'package:carwash/screen/ChangePassword.dart';
import 'package:carwash/screen/Customers.dart';
import 'package:carwash/screen/Home.dart';
import 'package:carwash/screen/Invoice.dart';
import 'package:carwash/screen/Login.dart';
import 'package:carwash/screen/Profile.dart';
import 'package:carwash/screen/Subscription.dart';
import 'package:carwash/viewmodel/IndexViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CWLayout extends StatefulWidget {
  final int selectedIndex;
  CWLayout({this.selectedIndex = 0});
  @override
  _CWLayoutState createState() => _CWLayoutState();
}

class _CWLayoutState extends State<CWLayout> {
  int _selectedIndex = 0;
  User? authUser;

  Future<void> _pullAuthUser() async {
    Provider.of<IndexViewModel>(context, listen: false).setUser(User());
    Provider.of<IndexViewModel>(context, listen: false).fetchUser();
  }
  @override
  void initState() {
    _selectedIndex = widget.selectedIndex;
    _pullAuthUser();
    super.initState();
  }

  final List<Widget> _pages = [
    HomeScreen(),
    ActivityPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {

    authUser = Provider.of<IndexViewModel>(context).getUser;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Const.primaryColor,
        title: Text('Car Wash App'),
      ),
      body: _pages[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: Const.hi(context)/3,
              color: Const.primaryColor,
              padding: EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 40, // Set the radius as needed
                        backgroundImage: AssetImage(Const.logo),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(3)
                        ),
                        child: Text('${authUser?.role?.toUpperCase()}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text('${authUser?.name}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),

                  SizedBox(height: 5,),
                  Text('${authUser?.email}',style: TextStyle(color: Colors.white)),
                  SizedBox(height: 20,),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CWLayout(selectedIndex: 2,)));
                // Handle profile menu action
              },
            ),

            if(authUser?.role==Role.manager)
              ListTile(
                leading: Icon(Icons.supervised_user_circle_rounded),
                title: Text('Customers'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerPage()));
                  // Handle packages menu action
                },
              ),
            if(authUser?.role==Role.manager)
            ListTile(
              leading: Icon(Icons.padding),
              title: Text('Packages'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionPage()));
                // Handle packages menu action
              },
            ),
            if(authUser?.role==Role.manager)
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Invoice'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => InvoicePage()));
                // Handle packages menu action
              },
            ),


            ListTile(
              leading: Icon(Icons.history),
              title: Text('Acivities'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CWLayout()));
                // Handle order history menu action
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Change Password'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordPage()));
                // Handle order history menu action
              },
            ),

            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: ()async {
                await ShPref.logout(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: BottomNavigationBar(
          backgroundColor: Colors.black, // Set the background color
          unselectedItemColor: Colors.white54, // Set the unselected item color
          selectedItemColor: Colors.white,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Order History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
