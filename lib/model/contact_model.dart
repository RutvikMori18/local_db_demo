/// id : 1
/// first_name : ""
/// last_name : ""
/// mobile : ""
/// email : ""
/// image_path : ""
/// category_id : 10

class ContactModel {
  ContactModel({
    this.id,
    this.firstName,
    this.lastName,
    this.mobile,
    this.email,
    this.imagePath,
    this.categoryId,
  });

  ContactModel.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    email = json['email'];
    imagePath = json['image_path'];
    categoryId = json['category_id'];
  }
  num? id;
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  String? imagePath;
  num? categoryId;
  ContactModel copyWith({
    num? id,
    String? firstName,
    String? lastName,
    String? mobile,
    String? email,
    String? imagePath,
    num? categoryId,
  }) =>
      ContactModel(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        mobile: mobile ?? this.mobile,
        email: email ?? this.email,
        imagePath: imagePath ?? this.imagePath,
        categoryId: categoryId ?? this.categoryId,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['mobile'] = mobile;
    map['email'] = email;
    map['image_path'] = imagePath;
    map['category_id'] = categoryId;
    return map;
  }
}
