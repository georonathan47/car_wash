import 'package:carwash/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

class ActiveOrderScreen extends StatelessWidget {
  final List<CarSubscription> activeOrders = [
    CarSubscription('Car 1', DateTime(2023, 8, 6)),
    CarSubscription('Car 2', DateTime(2023, 8, 10)),
    // ... Add more active orders here
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: activeOrders.length,
      itemBuilder: (context, index) {
        return OrderTimelineCard(activeOrders[index]);
      },
    );
  }
}

class CarSubscription {
  final String carName;
  final DateTime subscriptionDate;

  CarSubscription(this.carName, this.subscriptionDate);
}

class OrderTimelineCard extends StatelessWidget {
  final CarSubscription carSubscription;

  OrderTimelineCard(this.carSubscription);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Car: ${carSubscription.carName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Subscription Date: ${DateFormat.yMMMMd().format(carSubscription.subscriptionDate)}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            TimelineWidget(carSubscription.subscriptionDate),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement cancel subscription logic here
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: Text('Cancel Subscription'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TimelineWidget extends StatelessWidget {
  final DateTime subscriptionDate;

  TimelineWidget(this.subscriptionDate);

  @override
  Widget build(BuildContext context) {
    final sundaysInMonth = [];

    DateTime currentDate = subscriptionDate;
    while (currentDate.month == subscriptionDate.month) {
      if (currentDate.weekday == DateTime.sunday) {
        sundaysInMonth.add(currentDate);
      }
      currentDate = currentDate.add(Duration(days: 1));
    }

    return Container(
      height: MediaQuery.of(context).size.height/2,
      child: Timeline(
        lineColor:Colors.black,
        children:[
          for(int i = 0; i < sundaysInMonth.length; i++)...[
            TimelineModel(
              Container(
              height: 100,
              child: Row(
                children: [
                  Text(DateFormat('MMM dd').format(sundaysInMonth[i])),
                  Spacer(),
                  Icon(Icons.check_circle_outline,color: i+1 == sundaysInMonth.length?Colors.green:Colors.black,),
                  SizedBox(width: 16),
                  Icon(Icons.payment_outlined),
                ],
              ),
            ),
            icon: Icon(Icons.receipt, color: Colors.white,size: 10,),
            iconBackground: i+1 == sundaysInMonth.length?Colors.green:Colors.black,
            )
          ],
        ],

        position: TimelinePosition.Left,
        iconSize: 40,
      ),
    );

  }
}
