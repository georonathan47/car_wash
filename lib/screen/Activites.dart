import 'package:carwash/apis/api_response.dart';
import 'package:carwash/constants.dart';
import 'package:carwash/model/Activity.dart';
import 'package:carwash/viewmodel/IndexViewModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ActivityPage extends StatefulWidget {
  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  List<Activity?> activities = [];

  Future<void> _pullActivities() async {
    Provider.of<IndexViewModel>(context, listen: false).setActivity([]);
    Provider.of<IndexViewModel>(context, listen: false).fetchActivity({});
  }
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<IndexViewModel>(context, listen: false).setActivity([]);
      _pullActivities();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    IndexViewModel _indexViewModel=Provider.of<IndexViewModel>(context);
    activities = _indexViewModel.getActivities;

    return (_indexViewModel.getStatus.status == Status.IDLE)
        ? (activities.length==0)
          ? Container(
              padding: EdgeInsets.all(30),
              child: Text('No Activities'),
            )
          : ListView.builder(
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(16),
          child: ListTile(
            title: Text(
              '${activities[index]?.message}',
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text(
              '${activities[index]?.created_at}',
              style: TextStyle(fontSize: 16, color: Colors.grey,),textAlign: TextAlign.right,
            ),
          ),
        );
      },
    )
        : Container(
            width: Const.wi(context),
            height: Const.hi(context)/1.3,
            child: Const.LoadingIndictorWidtet(),
        );
  }
}