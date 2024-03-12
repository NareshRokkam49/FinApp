class RendomDogRes {
  String? message;
  String? status;
  int? code;

  RendomDogRes({this.message, this.status, this.code});

  RendomDogRes.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['code'] = this.code;
    return data;
  }
}
