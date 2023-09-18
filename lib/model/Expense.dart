import 'package:carwash/model/Order.dart';
import 'package:carwash/model/User.dart';

class Expense {
  final int? id;
  final int? user_id;
  final String? type;
  final String? narration;
  final String? date;
  final String? amount;
  final String? image;
  final User? user;

  Expense({
    this.id,
    this.user_id,
    this.type,
    this.narration,
    this.amount,
    this.date,
    this.image,
    this.user,
  });



  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id :json['id'] as int?,
      user_id :json['user_id'] as int?,
      type :json['type'] as String?,
      narration:json['narration'] as String?,
      amount:json['amount'] as String?,
      image:json['image'] as String?,
      date:json['date'] as String?,
      user:json['user'] as User?,
    );
  }
}