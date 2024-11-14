class AnswerRequestModel {
  bool? success;
  AnswerRequestSubModel? data;

  AnswerRequestModel({this.success, this.data});

  AnswerRequestModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new AnswerRequestSubModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AnswerRequestSubModel {
  String? uId;
  String? sdp;
  String? type;

  AnswerRequestSubModel({this.uId, this.sdp, this.type});

  AnswerRequestSubModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    sdp = json['sdp'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uId'] = this.uId;
    data['sdp'] = this.sdp;
    data['type'] = this.type;
    return data;
  }
}
