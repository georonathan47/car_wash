
import 'package:carwash/model/Order.dart';

class Task {
  int? id;
  int? order_id;
  String? date;
  int? status;
  bool? accessor;
  Order? order;
  List<String>? images;

  Task(
      {this.id,
        this.order_id,
        this.accessor,
        this.order,
        this.date,
        this.images,
        this.status});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    order_id = json['order_id'];
    date = json['date'];
    status = json['status'];
    accessor = json['accessor'];
    order = json['order'] as Order?;
    images = json['images'] as List<String>?;
  }

}
