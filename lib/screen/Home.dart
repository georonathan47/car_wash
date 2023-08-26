import 'package:carwash/constants.dart';
import 'package:carwash/model/Product.dart';
import 'package:carwash/screen/SubscribeProduct.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<Product> subscriptionProducts = [
    Product('Simple Wash', 'Basic car wash', 20),
    Product('Car Wash and Polish', 'Wash and polish package', 40),
    Product('Deluxe Car Care', 'Complete car care package', 60),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: ListView.builder(
        itemCount: subscriptionProducts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SubscribeProduct(subscriptionProducts[index])));
            },
            child: SubscriptionCard(subscriptionProducts[index]),
          );
        },
      ),
    );
  }
}



class SubscriptionCard extends StatelessWidget {
  final Product product;

  SubscriptionCard(this.product);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Const.logo),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  product.description,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
