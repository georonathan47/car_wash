class Customer {
  final int? id;
  final String? name;
  final String? location;
  final String? phone;
  final String? profile;
  Customer({ this.id,  this.name,  this.location, this.phone, this.profile});


  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id :json['id'] as int?,
      name: json['name'] as String?,
      location : json['address'] as String?,
      phone : json['phone'] as String?,
      profile : json['profile'] as String?,
    );
  }
}