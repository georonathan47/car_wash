import 'package:carwash/constants.dart';
import 'package:carwash/model/Subscription.dart';
import 'package:carwash/viewmodel/IndexViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carwash/apis/api_response.dart';



class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {


  List<Subscription?> subscriptions=[];
  List<bool?> updateSubscriptionBool=[false,false,false];

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _idController = TextEditingController();


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
    IndexViewModel indexViewModel=Provider.of<IndexViewModel>(context);
    subscriptions = indexViewModel.getSubscriptionList;
    return Scaffold(
      appBar: Const.appbar('Packages'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(indexViewModel.getStatus.status ==  Status.IDLE)
                    if(subscriptions.isEmpty)
                      const Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: Text('No Subscription',textAlign: TextAlign.center,),
                        ),
                      )
                    else
                      for(int i=0;i<subscriptions.length;i++)
                        SizedBox(
                          width: Const.wi(context)/1.2,
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
                                Visibility(
                                  visible: updateSubscriptionBool[i]==false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${subscriptions[i]?.title} Package',style: const TextStyle(fontWeight: FontWeight.bold),),
                                        (subscriptions[i]?.is_recurring== SubscriptionType.recurring)
                                        ? const Icon(Icons.refresh)
                                        : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: updateSubscriptionBool[i]==false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${subscriptions[i]?.price} SAR'),
                                        InkWell(
                                          onTap: (){
                                            setState(() {
                                              _titleController.text='${subscriptions[i]?.title}';
                                              _priceController.text='${subscriptions[i]?.price}';
                                              _idController.text='${subscriptions[i]?.id}';
                                              updateSubscriptionBool[i]=true;
                                            });
                                          },
                                          child: const Text('Update',style: TextStyle(fontWeight: FontWeight.bold),),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: updateSubscriptionBool[i]==true,
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [

                                        TextField(
                                          controller: _titleController,
                                          decoration: InputDecoration(
                                            labelText: 'Title',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        TextField(
                                          controller: _priceController,
                                          decoration: InputDecoration(
                                            labelText: 'Price',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: (){
                                                setState(() { updateSubscriptionBool[i]=false; });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.only(left: 5),
                                                  child: const Text('Cancel',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
                                              ),
                                            ),

                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white, backgroundColor: Const.primaryColor, minimumSize: const Size(100, 40),
                                                textStyle: const TextStyle(color: Colors.black, fontSize: 18),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                              ),
                                              child: const Text('Update'),
                                              onPressed: () async{
                                                if (_titleController.text.isEmpty) {
                                                  Const.toastMessage('Title is required.');
                                                } else if (_priceController.text.isEmpty) {
                                                  Const.toastMessage('Price is required.');
                                                } else {
                                                  Map<String,dynamic> data = {
                                                    'id': _idController.text,
                                                    'title': _titleController.text,
                                                    'price': _priceController.text,
                                                  };
                                                  try{
                                                    Map response=await indexViewModel.updatePackage(data);
                                                  }catch(e){
                                                    print('e');
                                                  }
                                                }

                                              },
                                            ),

                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )

                  else if (indexViewModel.getStatus.status == Status.BUSY)
                    SizedBox(
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
