
class Trx {
  final int? id;
  final int? order_id;
  final String? narration;
  final String? date;
  final String? amount;

  Trx({
    this.id,
    this.order_id,
    this.narration,
    this.date,
    this.amount,
  });



  factory Trx.fromJson(Map<String, dynamic> json) {
    return Trx(
      id :json['id'] as int?,
      order_id :json['order_id'] as int?,
      narration :json['narration'] as String?,
      date :json['date'] as String?,
      amount :json['amount'] as String?,
    );
  }
}