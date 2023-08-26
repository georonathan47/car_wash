import 'package:carwash/constants.dart';
import 'package:carwash/screen/Active.dart';
import 'package:carwash/screen/Activites.dart';
import 'package:carwash/screen/ChangePassword.dart';
import 'package:carwash/screen/Home.dart';
import 'package:carwash/screen/Profile.dart';
import 'package:flutter/material.dart';

class CWLayout extends StatefulWidget {
  @override
  _CWLayoutState createState() => _CWLayoutState();
}

class _CWLayoutState extends State<CWLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    ActiveOrderScreen(),
    ActivityPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Const.primaryColor1,
        title: Text('Car Wash App'),
      ),
      body: _pages[_selectedIndex],
      drawer: SideBarMenu(),
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
              icon: Icon(Icons.assignment),
              label: 'Active Order',
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

class SideBarMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: Const.hi(context)/3,
            color: Const.primaryColor1,
            padding: EdgeInsets.only(left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                SizedBox(height: 20,),
                Text('John Doe',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                SizedBox(height: 5,),
                Text('johndoe@gmail.com',style: TextStyle(color: Colors.white)),
                SizedBox(height: 20,),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CWLayout()));
              // Handle profile menu action
            },
          ),
          ListTile(
            leading: Icon(Icons.padding),
            title: Text('Packages'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CWLayout()));
              // Handle packages menu action
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Active Orders'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CWLayout()));
              // Handle active orders menu action
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
            onTap: () {
              Navigator.pop(context);
              // Handle logout menu action
            },
          ),
        ],
      ),
    );
  }
}

