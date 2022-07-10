// ignore_for_file: unnecessary_this, unnecessary_new, prefer_collection_literals

class User {
  String? name;
  String? email;
  String? datereg;
  String? phoneNo;
  String? homeAdd;
  String? cart;

  User({this.name, this.email, this.datereg, this.phoneNo, this.homeAdd, this.cart});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    datereg = json['datereg'];
    phoneNo = json['phoneNo'];
    homeAdd = json['homeAdd'];
    cart = json['cart'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['datereg'] = this.datereg;
    data['phoneNo'] = this.phoneNo;
    data['homeAdd'] = this.homeAdd;
    data['cart'] = cart.toString();
    return data;
  }
}