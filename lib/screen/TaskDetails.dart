import 'dart:io';

import 'package:carwash/apis/api_response.dart';
import 'package:carwash/app_url.dart';
import 'package:carwash/constants.dart';
import 'package:carwash/model/Task.dart';
import 'package:carwash/model/User.dart';
import 'package:carwash/screen/ShowLocation.dart';
import 'package:carwash/viewmodel/IndexViewModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';


class TaskScreen extends StatefulWidget {
  final Task? task;
  const TaskScreen({super.key, required this.task});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {


  Task? task;
  Future<void> _pullTask() async {
    Provider.of<IndexViewModel>(this.context, listen: false).setTask(Task());
    Provider.of<IndexViewModel>(this.context, listen: false).fetchTask({'id': widget.task?.id.toString()});
  }
  XFile? imagePath;
  bool isSelectedFile=false;

  String? selectedImageType;

  void getImage(String type) async {
    final ImagePicker picker = ImagePicker();
    imagePath = await picker.pickImage(
      source: (type == 'gallery') ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 100,
      maxHeight: 1000,
    );
    if (imagePath != null) {
      File file = File(imagePath!.path);
      double temp = file.lengthSync() / (1024 * 1024);
      setState(() {
        isSelectedFile = true;
      });
    } else {
      setState(() {
        isSelectedFile = false;
      });
      Const.toastMessage('Image not selected!');
    }
  }

  String? authRole;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authRole= await ShPref.getAuthRole();
      await _pullTask();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    IndexViewModel indexViewModel=Provider.of<IndexViewModel>(context);
    task=indexViewModel.getTask;

    return Scaffold(
      appBar: Const.appbar('Task Details'),
      body: RefreshIndicator(
        onRefresh: ()async{
          await _pullTask();
        },
        child: SizedBox(
          width: Const.wi(context),
          height: Const.hi(context),
          child: ListView(
            children: [
              Container(
                width: double.infinity,
                padding:const EdgeInsets.all(10),
                child: Card(
                  child: Container(
                    padding:const EdgeInsets.all(10),
                    child:

                    (indexViewModel.getStatus.status == Status.IDLE)
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Customer :',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.blueGrey),),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${task?.order?.user?.name}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                            InkWell(
                              onTap: () async{
                                String phone='${task?.order?.user?.phone}';
                                try{
                                  final call = Uri.parse('tel:$phone');
                                  if (await canLaunchUrl(call)) {
                                    launchUrl(call);
                                  } else {
                                    Const.toastMessage('Phone format not correct');
                                  }
                                }catch(e){
                                  Const.toastMessage('Phone format not correct');
                                }
                              },
                                child: Text('${task?.order?.user?.phone}')
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            Icon(Icons.pin_drop,size:20,
                                color: task?.order?.user?.long == null ? Colors.red : Colors.green
                            ),
                            SizedBox(
                              width: Const.wi(context)/1.3,
                              child: InkWell(
                                onTap: (){
                                  if(task?.order?.user?.long != null){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ShowLocation(
                                        User(
                                          id: task?.order?.user?.id,
                                          name: task?.order?.user?.name,
                                          long: task?.order?.user?.long,
                                          lat: task?.order?.user?.lat,
                                          address: task?.order?.user?.location,
                                        )
                                    )));
                                  }
                                },
                                  child: Text('${task?.order?.user?.location}',overflow: TextOverflow.fade,
                                    style: TextStyle(color: task?.order?.user?.long == null ? Colors.red : Colors.green),
                                  )
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 50,),
                        const Text('Car Details :',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.blueGrey),),
                        const Divider(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${task?.order?.car?.make}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                            Text('${task?.order?.car?.model}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('${task?.order?.car?.plate}'),
                          ],
                        ),


                        const SizedBox(height: 50,),
                        const Text('Payment Details :',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.blueGrey),),
                        const Divider(),
                        Text('Order # ${task?.order?.id.toString().padLeft(4, '0')}'),
                        const Divider(),

                        (task?.order?.payment == OrderPayment.pending)?
                        Row(
                          mainAxisAlignment: imagePath==null ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            (imagePath!=null && selectedImageType=='order')
                                ? Container(
                              width: Const.wi(context) / 5,
                              height: Const.wi(context) / 5,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey, // Color of the dashed border
                                  width: 1, // Width of the dashed border
                                ),
                                borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
                                shape: BoxShape.rectangle,
                              ),
                              child: Image.file(File(imagePath!.path)),
                            ): Container(),

                            (imagePath==null) ? InkWell(
                              onTap: (){
                                getImage('gallery');
                                setState(() {
                                  selectedImageType='order';
                                });
                              },
                              child: Container(
                                width: Const.wi(context) / 10,
                                height: Const.wi(context) / 10,
                                margin: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey, // Color of the dashed border
                                    width: 1, // Width of the dashed border
                                  ),
                                  borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
                                  shape: BoxShape.rectangle,
                                ),
                                child: Icon(
                                  Icons.image,
                                  size: 25,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ) : Container(),
                            (imagePath==null)  ? InkWell(
                              onTap: (){
                                getImage('camera');
                                setState(() {
                                  selectedImageType='order';
                                });
                              },
                              child: Container(
                                width: Const.wi(context) / 10,
                                height: Const.wi(context) / 10,
                                margin: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey, // Color of the dashed border
                                    width: 1, // Width of the dashed border
                                  ),
                                  borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
                                  shape: BoxShape.rectangle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 25,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ) : Container(),


                            (imagePath!=null && selectedImageType=='order') ? Container(
                              padding:const EdgeInsets.only(top: 10),
                              child: ElevatedButton(
                                onPressed: ()async {
                                  setState(() {
                                    imagePath=null;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey, // Background color
                                ),
                                child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                              ),
                            ) :Container(),
                            (imagePath!=null && selectedImageType=='order') ?  Container(
                              padding:const EdgeInsets.only(top: 10),
                              child: ElevatedButton(
                                onPressed: ()async {
                                  uploadFile(context,'receipt',task?.order?.id);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black, // Background color
                                ),
                                child: const Text('Upload', style: TextStyle(color: Colors.white)),
                              ),
                            ): Container() ,


                          ],
                        ) : Container(),

                        (task?.order?.receipt == null)
                        ? Container()
                        : Image.network(
                          Const.getReceiptPath(task?.order?.receipt),width: Const.wi(context)/3,
                          errorBuilder: (context, error, stackTrace) {
                            return Container();
                          },
                        ),





                        task?.order?.payment == OrderPayment.pending
                            ? Container(
                                margin: const EdgeInsets.only(right: 16.0),
                                child: ElevatedButton(
                                  onPressed: ()async {
                                    await indexViewModel.markPaymentAsDone({'id':'${task?.order?.id}'});
                                    _pullTask();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black, // Background color
                                  ),
                                  child: Text('Mark Order # ${task?.order?.id.toString().padLeft(4, '0')} as Paid', style: const TextStyle(color: Colors.white)),
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.only(right: 16.0),
                                child: ElevatedButton(
                                  onPressed: (){
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey, // Background color
                                  ),
                                  child: Text('Order was marked as paid on ${task?.order?.payment_date}', style: const TextStyle(color: Colors.white)),
                                ),
                              ),

                        const SizedBox(height: 50,),
                        const Text('Car Wash Status :',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.blueGrey),),
                        const Divider(),
                        task?.status == TaskStatus.pending
                            ? const Text('If you have washed the car. You can mark this car as washed.')
                            : const Text('This car was marked as washed'),



                        const SizedBox(height: 10,),


                        (task?.status == TaskStatus.pending)
                            ? (authRole ==  Role.technician)
                              ? Row(
                          mainAxisAlignment: imagePath==null ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            (imagePath!=null && selectedImageType=='task')
                                ? Container(
                              width: Const.wi(context) / 5,
                              height: Const.wi(context) / 5,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey, // Color of the dashed border
                                  width: 1, // Width of the dashed border
                                ),
                                borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
                                shape: BoxShape.rectangle,
                              ),
                              child: Image.file(File(imagePath!.path)),
                            ): Container(),

                            (imagePath==null) ? InkWell(
                              onTap: (){
                                getImage('gallery');
                                setState(() {
                                  selectedImageType='task';
                                });
                              },
                              child: Container(
                                width: Const.wi(context) / 10,
                                height: Const.wi(context) / 10,
                                margin: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey, // Color of the dashed border
                                    width: 1, // Width of the dashed border
                                  ),
                                  borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
                                  shape: BoxShape.rectangle,
                                ),
                                child: Icon(
                                  Icons.image,
                                  size: 25,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ) : Container(),
                            (imagePath==null)  ? InkWell(
                              onTap: (){
                                getImage('camera');
                                setState(() {
                                  selectedImageType='task';
                                });
                              },
                              child: Container(
                                width: Const.wi(context) / 10,
                                height: Const.wi(context) / 10,
                                margin: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey, // Color of the dashed border
                                    width: 1, // Width of the dashed border
                                  ),
                                  borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
                                  shape: BoxShape.rectangle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 25,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ) : Container(),


                            (imagePath!=null && selectedImageType=='task') ?  Container(

                            padding:const EdgeInsets.only(top: 10),
                              child: ElevatedButton(
                                onPressed: ()async {
                                  setState(() {
                                    imagePath=null;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey, // Background color
                                ),
                                child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                              ),
                            ) :Container(),
                            (imagePath!=null && selectedImageType=='task') ?  Container(

                              padding:const EdgeInsets.only(top: 10),
                              child: ElevatedButton(
                                onPressed: ()async {
                                  uploadFile(context,'task',task?.id);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black, // Background color
                                ),
                                child: const Text('Upload', style: TextStyle(color: Colors.white)),
                              ),
                            ) :Container(),





                          ],
                        )
                              : Container()
                            : Container(),

                        const SizedBox(height: 10,),

                        (task!.images!.isEmpty) ? Container() :
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:[
                              for(int f=0;f< task!.images!.length; f++)
                                SizedBox(
                                  width: Const.wi(context)/3,
                                  height: Const.wi(context)/3,
                                  child: Image.network(task!.images![f]),
                                  //child: Text('${task!.images![f]}'),
                                ),
                            ],
                          ),
                        ),






                        const SizedBox(height: 10,),
                        const Divider(),

                        task?.status == TaskStatus.pending && task!.images!.isNotEmpty
                            ? (authRole == Role.technician)? Container(
                                margin: const EdgeInsets.only(right: 16.0),
                                child: ElevatedButton(
                                  onPressed: ()async {
                                    await indexViewModel.taskMarkAsDone({'id':'${task?.id}'});
                                    _pullTask();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue, // Background color
                                  ),
                                  child: const Text('Mark as washed', style: TextStyle(color: Colors.white)),
                                ),
                              ): Container()
                            : Container(
                                margin: const EdgeInsets.only(right: 16.0),
                                child: ElevatedButton(
                                  onPressed: (){
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey, // Background color
                                  ),
                                  child: Text(task!.images!.isEmpty ?'Upload images first to mark as washed' :'Marked as Washed' , style: const TextStyle(color: Colors.white)),
                                ),
                              ),
                      ],
                    )
                    : SizedBox(
                      height: Const.hi(context)-100,
                      child: Center(
                        child: Const.LoadingIndictorWidtet(),
                      ),
                    ),
                  ),
                ),
              )
            ]
          ),
        ),
      ),
    );

  }




  Dio dio = Dio();
  uploadFile(context,type,id) async {
    String authToken=await ShPref.getAuthToken();
    String uploadUrl = type=='receipt'? AppUrl.uploadReceipt : AppUrl.uploadTaskImage;
    FormData? formData;
    if (imagePath != null) {
      String path;
      path = imagePath!.path;
      formData = FormData.fromMap(
        {
          'id':'$id',
          'image': await MultipartFile.fromFile(path, filename: basename(path)),
        },
      );
    } else {
      Const.toastMessage('Please select image to upload');
    }

    Response response = await dio.post(
      uploadUrl,
      data: formData,
      options: Options(
        headers: {
          "Accept": "application/json",
          'Authorization': "Bearer $authToken"
        },
        receiveTimeout: 200000,
        sendTimeout: 200000,
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );

    if (response.statusCode == 200){
      setState(() {
        imagePath=null;
      });
      await _pullTask();
      Const.toastMessage('Image is uploaded!');
    } else{
      Const.toastMessage('Something went wrong! Please try again!');
    }
  }



}