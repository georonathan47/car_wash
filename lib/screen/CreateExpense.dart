import 'package:carwash/apis/api_response.dart';
import 'package:carwash/constants.dart';
import 'package:carwash/model/User.dart';
import 'package:carwash/viewmodel/IndexViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateExpensePage extends StatefulWidget {
  @override
  _CreateExpensePageState createState() => _CreateExpensePageState();
}

class _CreateExpensePageState extends State<CreateExpensePage> {
  final TextEditingController typeController = TextEditingController();
  final TextEditingController narrationController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  bool _loading=false;


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    IndexViewModel _indexViewModel=Provider.of<IndexViewModel>(context);

    return SingleChildScrollView(
      child:
      (_indexViewModel.getStatus.status == Status.IDLE)?
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          TextButton(
            onPressed: () {
              // Implement logic to change profile image
            },
            child: /*Text('Change Profile Picture',style: TextStyle(color: Const.primaryColor),)*/ Container(),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                for(int i=0;i<Const.ExpenseTypes.length;i++)
                  CheckboxListTile(
                    title: Text('${Const.ExpenseTypes[i]}'),
                    value: false,
                    onChanged: (value) {
                      setState(() {
                        typeController.text = Const.ExpenseTypes[i];
                      });
                    },
                  ),
                SizedBox(height: 16),
                TextField(
                  enabled: false,
                  controller:narrationController,
                  decoration: InputDecoration(labelText: 'Narration'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller:amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Const.primaryColor, // Set the background color to black
                      ),
                      onPressed: ()async {
                        if (typeController.text.isEmpty) {
                          Const.toastMessage('Type is required.');
                        } else if (narrationController.text.isEmpty) {
                          Const.toastMessage('Narration is required.');
                        } else if (amountController.text.isEmpty) {
                          Const.toastMessage('Amount is required.');
                        } else {
                          Map<String, dynamic> data = {
                            'type':typeController.text,
                            'narration': narrationController.text,
                            'amount': amountController.text,
                          };
                          if(!_loading){
                            try{
                              setState(() { _loading=true; });
                              Map response=await _indexViewModel.createExpense(data);
                              Navigator.pop(context);
                            }catch(e){

                            }
                            setState(() { _loading=true; });
                          }
                        }
                      },
                      child: Text(_loading ? 'Processing..' : 'Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ): Container(
        width: double.infinity,
        height: Const.hi(context)-100,
        child: Center(
          child: Const.LoadingIndictorWidtet(),
        ),
      ),
    );
  }
}
