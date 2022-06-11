// ignore_for_file: unnecessary_new, prefer_collection_literals, unnecessary_this

class Subject {
  String? subjectId;
  String? subjectName;
  String? subjectDescription;
  String? subjectPrice;
  String? subjectSessions;
  String? subjectRating;

  Subject(
      {this.subjectId,
      this.subjectName,
      this.subjectDescription,
      this.subjectPrice,
      this.subjectSessions,
      this.subjectRating});

  Subject.fromJson(Map<String, dynamic> json) {
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
    subjectDescription = json['subject_description'];
    subjectPrice = json['subject_price'];
    subjectSessions = json['subject_sessions'];
    subjectRating = json['subject_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_id'] = this.subjectId;
    data['subject_name'] = this.subjectName;
    data['subject_description'] = this.subjectDescription;
    data['subject_price'] = this.subjectPrice;
    data['subject_sessions'] = this.subjectSessions;
    data['subject_rating'] = this.subjectRating;
    return data;
  }
}