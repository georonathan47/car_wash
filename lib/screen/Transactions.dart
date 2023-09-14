import 'package:carwash/apis/api_response.dart';
import 'package:carwash/constants.dart';
import 'package:carwash/model/Activity.dart';
import 'package:carwash/viewmodel/IndexViewModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:carwash/model/Trx.dart';

class TransactionsPage extends StatefulWidget {
  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  List<Trx?> trx = [];

  Future<void> _pullTrx() async {
    Provider.of<IndexViewModel>(context, listen: false).setTrx([]);
    Provider.of<IndexViewModel>(context, listen: false).fetchTrx({});
  }
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _pullTrx();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    IndexViewModel _indexViewModel=Provider.of<IndexViewModel>(context);
    trx = _indexViewModel.getTrx;

    return Scaffold(
      appBar: Const.appbar('My Transactions'),
      body: (_indexViewModel.getStatus.status == Status.IDLE)
          ? (trx.length==0)
            ? Container(
                padding: EdgeInsets.all(30),
                child: Text('No transactions'),
              )
            : ListView.builder(
        itemCount: trx.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(16),
            child: ListTile(
              title: Text(
                '${trx[index]?.narration}',
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${trx[index]?.amount} SAR',
                      style: TextStyle(fontSize: 16, color: Colors.grey,),textAlign: TextAlign.right,
                    ),
                    Text(
                      '${trx[index]?.date}',
                      style: TextStyle(fontSize: 16, color: Colors.grey,),textAlign: TextAlign.right,
                    ),

                  ],
                ),
              ),
            ),
          );
        },
      )
          : Container(
              width: Const.wi(context),
              height: Const.hi(context)/1.3,
              child: Const.LoadingIndictorWidtet(),
          ),
    );
  }
}