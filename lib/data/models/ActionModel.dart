class ActionModel {
  String? action;
  dynamic message;

  ActionModel({this.action, this.message});

  ActionModel.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = this.action;
    if (this.message != null) {
      data['message'] = message;
    }
    return data;
  }
}
