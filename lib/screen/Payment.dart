import 'package:carwash/constants.dart';
import 'package:carwash/model/Car.dart';
import 'package:carwash/viewmodel/IndexViewModel.dart';
import 'package:flutter/material.dart';
import 'package:checkout_sdk_flutter/checkout_sdk_flutter.dart';
import 'package:provider/provider.dart';
class PaymentPage extends StatefulWidget {
  final Car? car;
  const PaymentPage({super.key, required this.car});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {


  var cko = Checkout(publicKey: Const.CHECKOUT_PUBLIC_KEY);
  bool _loading=false;

  checkout()async{
    if(!_loading){
      setState(() { _loading=true; });
      int? expiryMonth=int.tryParse(_expiryMonthController.text);
      int? expiryYear=int.tryParse(_expiryYearController.text);
      final request = CardTokenizationRequest(number: _cardNumberController.text, expiryMonth: expiryMonth!, expiryYear: expiryYear!, cvv: _cvvController.text, name: "John Smith");
      try {
        var res = await cko.tokenizeCard(request);
        Map<String,dynamic> data = {
          'token':res.token,
          'name': _nameController.text,
          'card_number': _cardNumberController.text,
          'expiry_month': _expiryMonthController.text,
          'expiry_year': _expiryYearController.text,
          'order_id': widget.car?.order?.id.toString(),
        };

        try{
          Map response=await Provider.of<IndexViewModel>(context,listen: false).checkout(data);
          Navigator.pop(context);
        }catch(e){

        }
        setState(() { _loading=false; });


      } on UnauthorizedError catch (exception) {
        print(exception);
      } on InvalidDataError catch (exception) {
        print(exception);
      } catch (error) {
        print(error);
      }
    }

  }


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

    });
    super.initState();
  }


  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryMonthController = TextEditingController();
  final TextEditingController _expiryYearController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Const.appbar('Checkout'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text('Order # ${widget.car?.order?.id.toString().padLeft(4, '0')}',style: const TextStyle(fontSize: 20),),
              const Divider(),
              Text('Payment of Order # ${widget.car?.order?.id.toString().padLeft(4, '0')} against '
                  '${widget.car?.make} , ${widget.car?.model} # ${widget.car?.plate}.',style: const TextStyle(fontSize: 16),),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  decoration: InputDecoration(
                    labelText: 'Card Number (16 digits)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _expiryMonthController,
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      decoration: InputDecoration(
                        labelText: 'Expiry Month',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _expiryYearController,
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      decoration: InputDecoration(
                        labelText: 'Expiry Year',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: _cvvController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  ElevatedButton(
                    onPressed: () async{
                      if(!_loading){
                        if(_nameController.text.isEmpty){
                          Const.toastMessage('Name is required!');
                        }else
                        if(_cardNumberController.text.isEmpty){
                          Const.toastMessage('Card number is required!');
                        }else
                        if(_expiryMonthController.text.isEmpty){
                          Const.toastMessage('Expiry month is required!');
                        }else
                        if(_expiryMonthController.text.isEmpty){
                          Const.toastMessage('Expiry year is required!');
                        }else
                        if(_expiryMonthController.text.isEmpty){
                          Const.toastMessage('CVV is required!');
                        }else{
                          await checkout();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Const.primaryColor, minimumSize: Size((MediaQuery.of(context).size.width / 2.5), 60,),
                      textStyle: const TextStyle(color: Colors.black, fontSize: 22),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(_loading?'Processing..':'Pay ${widget.car?.order?.price} SAR'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
