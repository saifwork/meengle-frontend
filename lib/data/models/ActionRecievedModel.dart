class AnswerRecievedModel {
  bool? success;
  AnswerRecievedSubModel? data;

  AnswerRecievedModel({this.success, this.data});

  AnswerRecievedModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? new AnswerRecievedSubModel.fromJson(json['data'])
        : null;
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

class AnswerRecievedSubModel {
  String? uId;
  String? answer;
  String? type;

  AnswerRecievedSubModel({this.uId, this.answer, this.type});

  AnswerRecievedSubModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    answer = json['answer'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uId'] = this.uId;
    data['answer'] = this.answer;
    data['type'] = this.type;
    return data;
  }
}
