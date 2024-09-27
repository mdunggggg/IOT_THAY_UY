class ActionModel {
  int? id;
  String? deviceId;
  String? appliance;
  String? applianceCode;
  String? action;
  String? actionCode;
  int? time;

  ActionModel(
      {this.id,
        this.deviceId,
        this.appliance,
        this.applianceCode,
        this.action,
        this.actionCode,
        this.time});

  ActionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deviceId = json['deviceId'];
    appliance = json['appliance'];
    applianceCode = json['applianceCode'];
    action = json['action'];
    actionCode = json['actionCode'];
    DateTime time = DateTime.parse(json['time']);
    this.time = time.millisecondsSinceEpoch;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['deviceId'] = this.deviceId;
    data['appliance'] = this.appliance;
    data['applianceCode'] = this.applianceCode;
    data['action'] = this.action;
    data['actionCode'] = this.actionCode;
    data['time'] = this.time;
    return data;
  }
}
