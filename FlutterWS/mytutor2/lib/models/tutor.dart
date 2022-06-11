// ignore_for_file: unnecessary_this, unnecessary_new, prefer_collection_literals

class Tutor {
  String? tutorId;
  String? tutorEmail;
  String? tutorPhone;
  String? tutorName;
  String? tutorPassword;
  String? tutorDescription;
  String? tutorDatereg;

  Tutor(
      {this.tutorId,
      this.tutorEmail,
      this.tutorPhone,
      this.tutorName,
      this.tutorPassword,
      this.tutorDescription,
      this.tutorDatereg});

  Tutor.fromJson(Map<String, dynamic> json) {
    tutorId = json['tutor_id'];
    tutorEmail = json['tutor_email'];
    tutorPhone = json['tutor_phone'];
    tutorName = json['tutor_name'];
    tutorPassword = json['tutor_password'];
    tutorDescription = json['tutor_description'];
    tutorDatereg = json['tutor_datereg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tutor_id'] = this.tutorId;
    data['tutor_email'] = this.tutorEmail;
    data['tutor_phone'] = this.tutorPhone;
    data['tutor_name'] = this.tutorName;
    data['tutor_password'] = this.tutorPassword;
    data['tutor_description'] = this.tutorDescription;
    data['tutor_datereg'] = this.tutorDatereg;
    return data;
  }
}