class ActionModel {
  int? id;
  String? deviceId;
  String? appliance;
  String? action;
  int? time;

  ActionModel({this.id, this.deviceId, this.appliance, this.action, this.time});

  ActionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deviceId = json['deviceId'];
    appliance = json['appliance'];
    action = json['action'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['deviceId'] = deviceId;
    data['appliance'] = appliance;
    data['action'] = action;
    data['time'] = time;
    return data;
  }
}
