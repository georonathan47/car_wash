import 'package:carwash/apis/api_response.dart';
import 'package:carwash/constants.dart';
import 'package:carwash/model/Customer.dart';
import 'package:carwash/model/Task.dart';
import 'package:carwash/model/TaskWithDate.dart';
import 'package:carwash/screen/CustomerDetails.dart';
import 'package:carwash/screen/TaskDetails.dart';
import 'package:carwash/viewmodel/IndexViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<void> _pullTasks() async {
    Provider.of<IndexViewModel>(context, listen: false).setTasksList([]);
    Provider.of<IndexViewModel>(context, listen: false).fetchTaskList({});
  }


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _pullTasks();

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    IndexViewModel _indexViewModel=Provider.of<IndexViewModel>(context);
    List<TaskWithDate?> tasks = _indexViewModel.getTasksList;

    return Scaffold(
      body: Container(
        width: Const.wi(context),
        height: Const.hi(context)-200,
        child: RefreshIndicator(
          onRefresh: ()async{
            await _pullTasks();
          },
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [


                    Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.grey.shade200,
                      child: Text('Upcomming',style: TextStyle(fontWeight: FontWeight.bold),),
                    ),

                    Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.blue.shade50,
                      child: Text('Pending',style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.green.shade100,
                      child: Text('Completed',style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),

              if(_indexViewModel.getStatus.status ==  Status.IDLE)
                if(tasks.length==0)
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: Const.hi(context)-100,
                      child: Center(
                        child: Text('No Task'),
                      ),
                    ),
                  )
                else
                  for(int x=0;x<tasks.length;x++)
                    Container(
                      margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                      width: Const.wi(context),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${tasks[x]?.date}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                              ],
                            ),
                            Container(
                              child: Column(
                                children: [
                                  for(int y=0; y < tasks[x]!.tasks!.length; y++ )
                                    InkWell(
                                      onTap:(){
                                        if(tasks[x]!.tasks![y].accessor==true){
                                          Task _tysk = tasks[x]!.tasks![y];
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => TaskScreen(task: _tysk,)));
                                        }else{
                                          Const.toastMessage('Its previous car washes are pending');
                                        }
                                      },
                                      child: Container(
                                        width: Const.wi(context)-10,
                                        padding: EdgeInsets.all(20),
                                        margin: EdgeInsets.all(5),
                                        color: (tasks[x]!.tasks![y].accessor == false)
                                              ? Colors.grey.shade200
                                              : (tasks[x]!.tasks![y].status==TaskStatus.complete)
                                                  ? Colors.green.shade100
                                                  : Colors.blue.shade50,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${tasks[x]!.tasks![y].order?.user?.name} ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                            Text('Car ➤ ${tasks[x]!.tasks![y].order?.car?.make} | ${tasks[x]!.tasks![y].order?.car?.model} | ${tasks[x]!.tasks![y].order?.car?.plate}'),
                                            Text('Status ➤ ${tasks[x]!.tasks![y].status == TaskStatus.pending ? ' Pending' : 'Done'}')
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
              else if (_indexViewModel.getStatus.status == Status.BUSY)
                Container(
                  width: Const.wi(context),
                  height: Const.hi(context)/1.2,
                  child:   Const.LoadingIndictorWidtet(),
                )
            ],
          ),
        ),
      ),
    );

  }
}






