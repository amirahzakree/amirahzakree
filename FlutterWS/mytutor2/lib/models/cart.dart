// ignore_for_file: unnecessary_this

class Cart{
  String? cartid;
  String? subname;
  String? subsession;
  String? subprice;
  String? cartqty;
  String? subid;
  String? totalprice;

  Cart(
    {
      this.cartid,
      this.subname,
      this.subsession,
      this.subprice,
      this.cartqty,
      this.subid,
      this.totalprice
    }
  );

  Cart.fromJson (Map<String, dynamic> json) {
    cartid = json['cart_id'];
    subname = json ['subject_name'];
    subsession = json ['subject_sessions'];
    subprice = json['subject_price'];
    cartqty = json ['cart_qty'];
    subid = json['subject_id'];
    totalprice = json ['totalprice'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = this.cartid;
    data['subject_name'] = this.subname;
    data['subject_sessions'] = this.subsession;
    data['subject_price'] = this.subprice;
    data['cart_qty'] = this.cartqty;
    data['subject_id'] = this.subid;
    data['totalprice'] = this.totalprice;
    return data;
  }
}