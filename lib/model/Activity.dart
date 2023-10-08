
class Activity {
  final int? id;
  final String? message;
  final String? created_at;

  Activity({
    this.id,
    this.message,
    this.created_at,
  });



  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id :json['id'] as int?,
      message :json['message'] as String?,
      created_at :json['created_at'] as String?,
    );
  }
}