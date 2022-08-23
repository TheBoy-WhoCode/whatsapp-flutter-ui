class GetTotalMessageCount {
  int? code;
  Data? data;

  GetTotalMessageCount({this.code, this.data});

  GetTotalMessageCount.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<String>? senders;
  int? totalSender;

  Data({this.senders, this.totalSender});

  Data.fromJson(Map<String, dynamic> json) {
    senders = json['senders'].cast<String>();
    totalSender = json['totalSender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['senders'] = senders;
    data['totalSender'] = totalSender;
    return data;
  }
}
