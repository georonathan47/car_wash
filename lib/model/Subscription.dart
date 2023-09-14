class Subscription {
  final int? id;
  final String? title;
  final String? price;
  final String? is_recurring;

  Subscription({required this.id, required this.title, required this.price,this.is_recurring});


  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id :json['id'] as int?,
      title: json['title'] as String?,
      price : json['price'] as String?,
      is_recurring : json['is_recurring'] as String?,
    );
  }
}