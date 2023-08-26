import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Activity {
  final String user;
  final String action;
  final DateTime date;

  Activity(this.user, this.action, this.date);
}

class ActivityPage extends StatelessWidget {
  final List<Activity> activities = [
    Activity('John Doe', 'Created a subscription', DateTime(2023, 8, 10)),
    Activity('John Doe', 'Cancelled subscription', DateTime(2023, 8, 15)),
    Activity('John Doe', 'Marked car wash as done', DateTime(2023, 8, 20)),
    Activity('John Doe', 'Paid to vendor of car wash', DateTime(2023, 8, 25)),
    Activity('John Doe', 'Created a subscription', DateTime(2023, 8, 10)),
    Activity('John Doe', 'Cancelled subscription', DateTime(2023, 8, 15)),
    Activity('John Doe', 'Marked car wash as done', DateTime(2023, 8, 20)),
    Activity('John Doe', 'Paid to vendor of car wash', DateTime(2023, 8, 25)),
    Activity('John Doe', 'Created a subscription', DateTime(2023, 8, 10)),
    Activity('John Doe', 'Cancelled subscription', DateTime(2023, 8, 15)),
    Activity('John Doe', 'Marked car wash as done', DateTime(2023, 8, 20)),
    Activity('John Doe', 'Paid to vendor of car wash', DateTime(2023, 8, 25)),

    // Add more activities here
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return ActivityCard(activities[index]);
      },
    );
  }
}

class ActivityCard extends StatelessWidget {
  final Activity activity;

  ActivityCard(this.activity);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: ListTile(
        title: Text(
          '${activity.user} ${activity.action}',
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Text(
          '${DateFormat.yMMMMd().format(activity.date)}',
          style: TextStyle(fontSize: 16, color: Colors.grey,),textAlign: TextAlign.right,
        ),
      ),
    );
  }
}
