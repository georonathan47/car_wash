import 'package:carwash/constants.dart';
import 'package:carwash/model/Order.dart';
import 'package:carwash/model/Product.dart';
import 'package:carwash/model/Subscription.dart';
import 'package:carwash/screen/CustomerDetails.dart';
import 'package:carwash/viewmodel/IndexViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carwash/apis/api_response.dart';



class InvoicePage extends StatefulWidget {
  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {


  List<Order?> invoices=[];
  String _filter='all';

  Future<void> _pullOrders() async {
    print(_filter);
    Provider.of<IndexViewModel>(context, listen: false).setInvoiceList([]);
    Provider.of<IndexViewModel>(context, listen: false).fetchInvoices(_filter);
  }
  _applyFilter(type)async{
    setState(() {
      _filter=type;
    });
    await _pullOrders();
  }


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<IndexViewModel>(context, listen: false).setInvoiceList([]);
      _pullOrders();
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
    invoices = _indexViewModel.getInvoiceList;

    return Scaffold(
      appBar: Const.appbar('Invoices'),
      body: RefreshIndicator(
        onRefresh: ()async{
          setState(() {
            _filter='all';
          });
          await _pullOrders();
        },
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: Const.wi(context)/1.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          InkWell(
                            onTap:()async{
                              _applyFilter('all');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              color: _filter=='all'?Colors.black12 : Colors.transparent,
                              child: Text('All ',style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                          ),
                          InkWell(
                            onTap:()async{
                              _applyFilter('pending');
                            },
                            child:Container(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              color: _filter=='pending'?Colors.red.shade100 : Colors.transparent,
                              child: Text('Pending ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),),
                            ),
                          ),
                          InkWell(
                            onTap:()async{
                              _applyFilter('complete');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              color: _filter=='complete'?Colors.green.shade100 : Colors.transparent,
                              child: Text('Complete ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green),),
                            ),

                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    if(_indexViewModel.getStatus.status ==  Status.IDLE)
                      if(invoices.length==0)
                        Center(
                          child: Container(
                            width: double.infinity,
                            child: Text('No Invoices',textAlign: TextAlign.center,),
                          ),
                        )
                      else
                        DataTable(
                          columns: [
                            DataColumn(label: Text('Invoice')),
                            DataColumn(label: Text('User')),
                            DataColumn(label: Text('Car')),
                            DataColumn(label: Text('Payment')),
                          ],
                          rows: List<DataRow>.generate(invoices.length, (index) => DataRow(
                              cells: [
                                DataCell(Text('Inv#${invoices[index]?.id.toString().padLeft(4, '0')}')),
                                DataCell(
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerDetail(customer: invoices[index]!.user!)));
                                    },
                                    child: Text('${invoices[index]?.user?.name}',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                                    ),
                                  ),
                                ),
                                DataCell(Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${invoices[index]?.car?.make}'),
                                    Text('${invoices[index]?.car?.plate}')
                                  ],
                                )),
                                DataCell(Text('${invoices[index]?.payment == OrderPayment.pending ? 'Pending' : 'Done'}')),
                              ],
                            ),
                          ),
                        )

                    else if (_indexViewModel.getStatus.status == Status.BUSY)
                      Container(
                        width: Const.wi(context),
                        height: Const.hi(context),
                        child:   Const.LoadingIndictorWidtet(),
                      ),
                  ]
                ),
              ),
            ),

          ],
        ),
      ),
    );

  }
}
