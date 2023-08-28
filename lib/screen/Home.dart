import 'package:carwash/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Subscription {
  final String customerName;
  final String location;
  final String carDetails;
  final List<DateTime> carWashTimes;

  Subscription(this.customerName, this.location, this.carDetails, this.carWashTimes);
}

class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;

  SubscriptionCard(this.subscription);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Const.logo),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Subscription Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Divider(),
                Text('Customer: ${subscription.customerName}'),
                Text('Location: ${subscription.location}'),
                Text('Car Details: ${subscription.carDetails}'),
                SizedBox(height: 8),
                Text(
                  'Car Wash Times:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: subscription.carWashTimes.map((dateTime) {
                    return Text(
                      DateFormat('MMM d, h:mm a').format(dateTime),
                      style: TextStyle(color: Colors.grey),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SubscriptionListScreen extends StatelessWidget {
  final List<Subscription> subscriptionList = [
    Subscription(
      'John Doe',
      '123 Main St',
      'Car Model: ABC123, Plate: XYZ456',
      [
        DateTime.now().add(Duration(days: 1, hours: 9)),
        DateTime.now().add(Duration(days: 8, hours: 9)),
        DateTime.now().add(Duration(days: 15, hours: 9)),
        DateTime.now().add(Duration(days: 22, hours: 9)),
      ],
    ),
    Subscription(
      'John Doe',
      '123 Main St',
      'Car Model: ABC123, Plate: XYZ456',
      [
        DateTime.now().add(Duration(days: 1, hours: 9)),
        DateTime.now().add(Duration(days: 8, hours: 9)),
        DateTime.now().add(Duration(days: 15, hours: 9)),
        DateTime.now().add(Duration(days: 22, hours: 9)),
      ],
    ),

    // Add more subscriptions here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView.builder(
        itemCount: subscriptionList.length,
        itemBuilder: (context, index) {
          return SubscriptionCard(subscriptionList[index]);
        },
      ),
    );
  }
}
