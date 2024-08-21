import 'package:home_tracking/api/dio.dart';
import 'package:injectable/injectable.dart';

@injectable
class MqttRepository {
  MqttRepository(this._dio);
  final BaseDio _dio;

  Future changeFan(bool value) async {
    try {
      final payload = {
        'message': value ? 'on' : 'off',
        'deviceId': 'IPhone 15 Pro'
      };
      await _dio.get('mqtt/turn-on-off-fan', data: payload);
    }
    catch(e) {
      print('Error changeFan: $e');
    }
  }

  Future changeLight(bool value) async {
    try {
      final payload = {
        'message': value ? 'on' : 'off',
        'deviceId': 'IPhone 15 Pro'
      };
      await _dio.get('mqtt/turn-on-off-light', data: payload);
    }
    catch(e) {
      print('Error changeLight: $e');
    }
  }

  Future changeAirConditioner(bool value) async {
    try {
      final payload = {
        'message': value ? 'on' : 'off',
        'deviceId': 'IPhone 15 Pro'
      };
      await _dio.get('mqtt/turn-on-off-air-condition', data: payload);
    }
    catch(e) {
      print('Error changeAirConditioner: $e');
    }
  }
}