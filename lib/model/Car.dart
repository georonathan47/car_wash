import 'package:carwash/model/Customer.dart';
import 'package:carwash/model/Order.dart';

class Car {
  final int? id;
  final String? user_id;
  final String? make;
  final String? model;
  final String? plate;
  final String? image;
  final Order? order;
  final Customer? customer;

  Car({
    this.id,
    this.user_id,
    this.make,
    this.model,
    this.plate,
    this.image,
    this.order,
    this.customer,
  });



  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id :json['id'] as int?,
      user_id :json['user_id'] as String?,
      make :json['make'] as String?,
      model: json['model'] as String?,
      plate : json['plate'] as String?,
      image : json['image'] as String?,
      order : json['order'] as Order?,
      customer : json['user'] as Customer?,
    );
  }
}