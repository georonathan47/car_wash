import 'package:carwash/apis/api_response.dart';
import 'package:carwash/constants.dart';
import 'package:carwash/model/Activity.dart';
import 'package:carwash/model/Expense.dart';
import 'package:carwash/viewmodel/IndexViewModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpensePage extends StatefulWidget {
  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  List<Expense?> expenses = [];

  Future<void> _pullExpenses() async {
    Provider.of<IndexViewModel>(context, listen: false).setExpense([]);
    Provider.of<IndexViewModel>(context, listen: false).fetchExpenses({});
  }
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _pullExpenses();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    IndexViewModel _indexViewModel=Provider.of<IndexViewModel>(context);
    expenses = _indexViewModel.getExpenses;

    return (_indexViewModel.getStatus.status == Status.IDLE)
        ? (expenses.length==0)
          ? Container(
              padding: EdgeInsets.all(30),
              child: Text('No Expense'),
            )
          : ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(16),
          child: ListTile(
            title: Text(
              '${expenses[index]?.narration}',
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text(
              '${expenses[index]?.date}',
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