class DataSensorModel {
  int? id;
  double? temperature;
  double? humidity;
  double? light;
  int? time;

  DataSensorModel(
      {this.id, this.temperature, this.humidity, this.light, this.time});

  DataSensorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    temperature = json['temperature'];
    humidity = json['humidity'];
    light = json['light'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['temperature'] = temperature;
    data['humidity'] = humidity;
    data['light'] = light;
    data['time'] = time;
    return data;
  }
}