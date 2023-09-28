import 'package:carwash/constants.dart';
import 'package:carwash/model/Customer.dart';
import 'package:carwash/model/Product.dart';
import 'package:carwash/model/Subscription.dart';
import 'package:carwash/viewmodel/IndexViewModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:carwash/apis/api_response.dart';

class CreateCar extends StatefulWidget {

  final Customer customer;
  CreateCar({required this.customer});

  @override
  _CreateCarState createState() => _CreateCarState();
}

class _CreateCarState extends State<CreateCar> {
  final TextEditingController makeController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();
  int? selectedSubscription = 0;
  List<Subscription?> subscriptions=[];
  List<String>? sundays=[];

  bool showTimeWidget=false;

  Future<void> _pullSubscriptions() async {
    Provider.of<IndexViewModel>(context, listen: false).fetchSubscriptions({});
  }
  Future<void> _pullSundays() async {
    Provider.of<IndexViewModel>(context, listen: false).set4Sundays([]);
    Provider.of<IndexViewModel>(context, listen: false).fetch4Sundays();
  }

  bool _isLoading=false;

  Map<int, dynamic> selectedDateTimeMap = {};

  List<DateTime?> selectedDates=[];



  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<IndexViewModel>(context, listen: false).setSubscriptions([]);
      _pullSubscriptions();
      _pullSundays();
    });
    super.initState();
  }
  @override
  void dispose() {
    makeController.dispose();
    modelController.dispose();
    plateNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    IndexViewModel _indexViewModel=Provider.of<IndexViewModel>(context);
    subscriptions = _indexViewModel.getSubscriptionList;
    sundays = _indexViewModel.get4Sundays;

    return Scaffold(
      appBar: Const.appbar('Add New Car'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Car Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            TextField(
              controller: makeController,
              decoration: InputDecoration(labelText: 'Make of Car'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: modelController,
              decoration: InputDecoration(labelText: 'Model of Car'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: plateNumberController,
              decoration: InputDecoration(labelText: 'Plate Number'),
            ),
            SizedBox(height: 40),
            Text(
              'Select Subscription:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Divider(),
          if(_indexViewModel.getStatus.status ==  Status.IDLE)...[
            if(subscriptions.length==0)
              Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Text('No Subscription',textAlign: TextAlign.center,),
                ),
              )
            else
              for(int i=0;i<subscriptions.length;i++)
                CheckboxListTile(
                  title: Text('${subscriptions[i]!.title} (${subscriptions[i]!.price} SAR)'),
                  value: subscriptions[i]!.id == selectedSubscription,
                  onChanged: (value) {
                    setState(() {
                      showTimeWidget=true;
                      selectedSubscription = subscriptions[i]!.id;
                    });
                  },
                ),
            SizedBox(height: 20),

            Visibility(
              visible: showTimeWidget,
              child: Text(
                'Select Date and Time:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),


            Visibility(
              visible: showTimeWidget,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: selectedSubscription == 3 ? 1:sundays!.length,
                itemBuilder: (context, index) {
                  DateTime selectedDateTime = DateTime.parse(sundays![index]);
                  if(selectedDates.length<4){
                    selectedDates.add(selectedDateTime);
                  }

                  return ElevatedButton(
                    onPressed: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (pickedTime != null) {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDateTime,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            selectedDateTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                            selectedDates[index] = selectedDateTime;
                          });
                        }
                      }
                    },
                    child: Text(DateFormat('yyyy-MM-dd').add_jm().format(selectedDates[index]!)),
                  );
                },
              ),

            ),





          ]
          else if (_indexViewModel.getStatus.status == Status.BUSY)...[
            Container(
              width: Const.wi(context),
              padding: EdgeInsets.all(20),
              child:   Const.LoadingIndictorWidtet(),
            ),
          ],


            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async{
                    String formattedDateTime = '';
                    int take = (selectedSubscription==3) ? 1 : 4;
                    selectedDates.take(take).forEach((dateTime) {
                      String date = DateFormat('yyyy-MM-dd').format(dateTime!);
                      String time = DateFormat('HH:mm').format(dateTime);
                      formattedDateTime += '$date#$time@';
                    });

                    if (makeController.text.isEmpty) {
                      Const.toastMessage('Make of card is required.');
                    } else if (modelController.text.isEmpty) {
                      Const.toastMessage('Model of car is required.');
                    } else if (plateNumberController.text.isEmpty) {
                      Const.toastMessage('Plate no. is required.');
                    } else if (selectedSubscription==0) {
                      Const.toastMessage('Subscription is required to be selected.');
                    } else {
                      if(!_isLoading){
                        setState(() { _isLoading=true; });


                        Map<String, dynamic> data = {
                          'make': makeController.text,
                          'model': modelController.text,
                          'plate': plateNumberController.text,
                          'date_time': formattedDateTime,
                          'user_id': widget.customer.id.toString(),
                          'subscription_id': selectedSubscription.toString(),
                        };
                        try{
                          dynamic response=await _indexViewModel.addCar(data);
                          Navigator.pop(context);
                        }catch (e){
                        }
                        setState(() { _isLoading=false; });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black, // Set background color to black
                  ),
                  child: Text(
                    _isLoading?'Processing':'Submit',
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
