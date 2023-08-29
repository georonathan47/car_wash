import 'package:carwash/constants.dart';
import 'package:carwash/model/Customer.dart';
import 'package:carwash/screen/CustomerDetails.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<Customer> customers = [
    Customer(id: '1', name: "John Doe", location: "New York",phone: '021839034850',profile: ''),
    Customer(id: '2', name: "Alice Smith", location: "Los Angeles",phone: '021839034850',profile: ''),
    Customer(id: '3', name: "Bob Johnson", location: "Chicago",phone: '021839034850',profile: ''),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two cards per row
        ),
        itemCount: customers.length,
        itemBuilder: (context, index) {
          return CustomerCard(
            customer: customers[index],
          );
        },
      ),
    );
  }
}

class CustomerCard extends StatelessWidget {
  final Customer customer;

  CustomerCard({required this.customer});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerDetail(customer: customer,)));

      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: new Border.all(
              color: Colors.grey
            )
        ),
        margin: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer: ${customer.name}',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.pin_drop_outlined,size: 14,),
                      Text(
                        ' ${customer.location}',
                        style: TextStyle(fontSize: 14.0),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Make: Corolla Model 2018 Plate # DUI89H',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            Spacer(),
            Container(
              color: Colors.black, // Black strip background
              width: double.infinity, // Take full width
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Date of Wash : 03-04-23',
                  style: TextStyle(fontSize: 14.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






