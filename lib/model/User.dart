class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? profile;
  String? role;
  String? long;
  String? lat;

  User(
      {this.id,
        this.name,
        this.email,
        this.phone,
        this.address,
        this.profile,
        this.long,
        this.lat,
        this.role
      });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    email = json['email'] as String?;
    phone = json['phone'] as String?;
    address = json['address'] as String?;
    profile = json['profile'] as String?;
    role = json['role'] as String?;
    long = json['long'] as String?;
    lat = json['lat'] as String?;
  }

}
