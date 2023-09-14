import 'package:carwash/constants.dart';
import 'package:carwash/model/Product.dart';
import 'package:carwash/model/Subscription.dart';
import 'package:carwash/viewmodel/IndexViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carwash/apis/api_response.dart';



class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {


  List<Subscription?> subscriptions=[];

  Future<void> _pullSubscriptions() async {
    Provider.of<IndexViewModel>(context, listen: false).fetchSubscriptions({});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<IndexViewModel>(context, listen: false).setSubscriptions([]);
      _pullSubscriptions();
    });
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    IndexViewModel _indexViewModel=Provider.of<IndexViewModel>(context);
    subscriptions = _indexViewModel.getSubscriptionList;
    return Scaffold(
      appBar: Const.appbar('Packages'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(_indexViewModel.getStatus.status ==  Status.IDLE)
                    if(subscriptions.length==0)
                      Center(
                        child: Container(
                          width: double.infinity,
                          child: Text('No Subscription',textAlign: TextAlign.center,),
                        ),
                      )
                    else
                      for(int i=0;i<subscriptions.length;i++)
                        Container(
                          width: Const.wi(context)/1.5,
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: Const.hi(context)/5,
                                  color: Colors.black,
                                  child: Image.asset('assets/gradient.jpeg'),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${subscriptions[i]?.title} Package',style: TextStyle(fontWeight: FontWeight.bold),),
                                      (subscriptions[i]?.is_recurring== SubscriptionType.recurring)
                                      ? Icon(Icons.refresh)
                                      : Container(),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${subscriptions[i]?.price} SAR'),
                                ),
                              ],
                            ),
                          ),
                        )

                  else if (_indexViewModel.getStatus.status == Status.BUSY)
                    Container(
                      width: Const.wi(context),
                      child:   Const.LoadingIndictorWidtet(),
                    ),
                ]
              ),
            ),

          ],
        ),
      ),
    );
  }
}
