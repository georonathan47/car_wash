import 'package:carwash/apis/api_response.dart';
import 'package:carwash/app_url.dart';
import 'package:carwash/constants.dart';
import 'package:carwash/model/Car.dart';
import 'package:carwash/model/Task.dart';
import 'package:carwash/model/TaskWithDate.dart';
import 'package:carwash/model/User.dart';
import 'package:carwash/screen/CustomerDetails.dart';
import 'package:carwash/screen/Payment.dart';
import 'package:carwash/screen/ShowLocation.dart';
import 'package:carwash/screen/TaskDetails.dart';
import 'package:carwash/viewmodel/IndexViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? authUser;

  String? authRole;

  Future<void> _pullTasks() async {
    Provider.of<IndexViewModel>(context, listen: false).setTasksList([]);
    Provider.of<IndexViewModel>(context, listen: false).fetchTaskList({});
  }
  Future<void> _pullMyCars() async {
    Provider.of<IndexViewModel>(context, listen: false).setMyCars([]);
    Provider.of<IndexViewModel>(context, listen: false).fetchMyCars({});
  }
  
  Future<void> _pullAuthUser() async {
    Provider.of<IndexViewModel>(context, listen: false).setUser(User());
    Provider.of<IndexViewModel>(context, listen: false).fetchUser();
  }


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

      authRole=await ShPref.getAuthRole();
      await _pullAuthUser();
      if(authRole ==  Role.customer){
        _pullMyCars();
      }else{
        _pullTasks();
      }

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    IndexViewModel indexViewModel=Provider.of<IndexViewModel>(context);
    List<TaskWithDate?> tasks = indexViewModel.getTasksList;

    authUser = indexViewModel.getUser;
    List<Car?> cars = indexViewModel.getMyCars;

    return Scaffold(
      body: SizedBox(
        width: Const.wi(context),
        height: Const.hi(context)-200,
        child: RefreshIndicator(
          onRefresh: ()async{
            if(authUser?.role == Role.customer){
              await _pullMyCars();
            }else{
              await _pullTasks();
            }
          },
          child: ListView(
            children: [
              if(authUser?.role==Role.customer)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: const Text('My Cars',style: TextStyle(fontSize: 25),),

                )
              else
                Container(
                  margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.grey.shade200,
                        child: const Text('Upcomming',style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.blue.shade50,
                        child: const Text('Pending',style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.green.shade100,
                        child: const Text('Completed',style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),

              if(indexViewModel.getStatus.status ==  Status.IDLE)
                if(authUser?.role==Role.customer)
                  if(cars.isEmpty)
                    SizedBox(
                      width: double.infinity,
                      height: Const.hi(context)/1.3,
                      child: const Center(
                        child: Text('No Cars'),
                      ),
                    )
                  else
                    for(int x=0;x<cars.length;x++)
                      Container(
                        margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
                        width: Const.wi(context),
                        child: Container(
                          color: Colors.grey.shade200,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${cars[x]?.make}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                  Text('${cars[x]?.model}',style: const TextStyle(fontSize: 20),),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${cars[x]?.plate}',style: const TextStyle(fontSize: 20),),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Container(height: 1,color: Colors.black12,),
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Order # ${cars[x]?.order?.id.toString().padLeft(4, '0')}',style: const TextStyle(fontSize: 20),),
                                  Text('${cars[x]?.order?.price} SAR',style: const TextStyle(fontSize: 20),),

                                ],
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      if(cars[x]?.order?.subscription_id!=3)
                                        const Icon(Icons.refresh),
                                      Text('${cars[x]?.order?.subscription?.title} ',style: const TextStyle(fontSize: 20),),
                                    ],
                                  ),

                                  Row(
                                    children: [

                                      ElevatedButton(
                                        onPressed: ()async {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerDetail(customer: cars[x]!.customer!,carId:  cars[x]!.id,))).then((value) => _pullMyCars());

                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black, // Background color
                                        ),
                                        child: const Text('Show Details', style: TextStyle(color: Colors.white)),
                                      ),
                                      const SizedBox(width: 10,),

                                      if(cars[x]?.order?.payment == OrderPayment.pending)
                                        ElevatedButton(
                                          onPressed: ()async {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage(car: cars[x],))).then((value) => _pullMyCars());

                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black, // Background color
                                          ),
                                          child: const Text('Pay Now', style: TextStyle(color: Colors.white)),
                                        ),

                                    ],
                                  )
                                ],
                              ),

                            ],
                          ),
                        ),
                      )
                else
                  if(tasks.isEmpty)
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: Const.hi(context)-100,
                        child: const Center(
                          child: Text('No Task'),
                        ),
                      ),
                    )
                  else
                    for(int x=0;x<tasks.length;x++)
                      Container(
                        margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
                        width: Const.wi(context),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${tasks[x]?.date}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                ],
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    for(int y=0; y < tasks[x]!.tasks!.length; y++ )
                                      InkWell(
                                        onTap:(){
                                          if(tasks[x]!.tasks![y].accessor==true){
                                            Task tysk = tasks[x]!.tasks![y];
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => TaskScreen(task: tysk,))).then((value) => _pullTasks());
                                          }else{
                                            Const.toastMessage('Its previous car washes are pending');
                                          }
                                        },
                                        child: Container(
                                          width: Const.wi(context)-10,
                                          padding: const EdgeInsets.all(20),
                                          margin: const EdgeInsets.all(5),
                                          color: (tasks[x]!.tasks![y].accessor == false)
                                              ? Colors.grey.shade200
                                              : (tasks[x]!.tasks![y].status==TaskStatus.complete)
                                              ? Colors.green.shade100
                                              : Colors.blue.shade50,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('${tasks[x]!.tasks![y].order?.user?.name} ',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),

                                                  if(tasks[x]!.tasks![y].order?.user?.long != null)
                                                    InkWell(
                                                      onTap: (){
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ShowLocation(
                                                            User(
                                                              id: tasks[x]!.tasks![y].order?.user?.id,
                                                              name: tasks[x]!.tasks![y].order?.user?.name,
                                                              long: tasks[x]!.tasks![y].order?.user?.long,
                                                              lat: tasks[x]!.tasks![y].order?.user?.lat,
                                                              address: tasks[x]!.tasks![y].order?.user?.location,
                                                            )
                                                        )));
                                                      },
                                                      child: const Icon(Icons.pin_drop_outlined),
                                                    )
                                                ],
                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('Car ➤ ${tasks[x]!.tasks![y].order?.car?.make} | ${tasks[x]!.tasks![y].order?.car?.model} | ${tasks[x]!.tasks![y].order?.car?.plate}'),
                                                      Text('Subscription ➤ ${tasks[x]!.tasks![y].order?.subscription?.title}'),
                                                      Text('Status ➤ ${tasks[x]!.tasks![y].status == TaskStatus.pending ? ' Pending' : 'Done'}')
                                                    ],
                                                  ),
                                                  (tasks[x]!.tasks![y].order?.car?.image == null)? Container():
                                                  Container(
                                                      padding: const EdgeInsets.all(10),
                                                      child: Center(
                                                        child: Image.network('${AppUrl.url}storage/car/${tasks[x]!.tasks![y].order?.car?.image}',width: 70,),
                                                      )
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                else if (indexViewModel.getStatus.status == Status.BUSY)
                SizedBox(
                  width: Const.wi(context),
                  height: Const.hi(context)/1.2,
                  child:   Const.LoadingIndictorWidtet(),
                ),
            ],
          ),
        ),
      ),
    );

  }
}






