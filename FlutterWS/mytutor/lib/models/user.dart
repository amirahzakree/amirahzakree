// ignore_for_file: unnecessary_this

class User {
  String? id;
  String? name;
  String? email;
  String? datereg;
  String? phoneNo;
  String? homeAdd;

  User({this.id, this.name, this.email, this.datereg, this.phoneNo, this.homeAdd});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    datereg = json['datereg'];
    phoneNo = json['phoneNo'];
    homeAdd = json['homeAdd'];
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['datereg'] = this.datereg;
    data['phoneNo'] = this.phoneNo;
    data['homeAdd'] = this.homeAdd;
    return data;
  }
}