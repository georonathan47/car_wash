class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? profile;
  String? role;

  User(
      {this.id,
        this.name,
        this.email,
        this.phone,
        this.address,
        this.profile,
        this.role});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    email = json['email'] as String?;
    phone = json['phone'] as String?;
    address = json['address'] as String?;
    profile = json['profile'] as String?;
    role = json['role'] as String?;
  }

}
