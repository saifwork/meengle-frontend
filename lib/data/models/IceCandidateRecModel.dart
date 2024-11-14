class IceCandidateRecModel {
  bool? success;
  IceCandidateRecSubModel? data;

  IceCandidateRecModel({this.success, this.data});

  IceCandidateRecModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new IceCandidateRecSubModel.fromJson(json['data']) : null;
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

class IceCandidateRecSubModel {
  String? uId;
  String? candidate;
  String? sdpMid;
  int? sdpMLineIndex;

  IceCandidateRecSubModel({this.uId, this.candidate, this.sdpMid, this.sdpMLineIndex});

  IceCandidateRecSubModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    candidate = json['candidate'];
    sdpMid = json['sdpMid'];
    sdpMLineIndex = json['sdpMLineIndex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uId'] = this.uId;
    data['candidate'] = this.candidate;
    data['sdpMid'] = this.sdpMid;
    data['sdpMLineIndex'] = this.sdpMLineIndex;
    return data;
  }
}
