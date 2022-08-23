class ForwardeMessageModel {
  int? code;
  String? message;

  ForwardeMessageModel({this.code, this.message});

  ForwardeMessageModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}
