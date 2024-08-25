import 'package:home_tracking/api/dio.dart';
import 'package:home_tracking/presentation/model/response.dart';
import 'package:injectable/injectable.dart';

@injectable
class MqttRepository {
  MqttRepository(this._dio);
  final BaseDio _dio;

  Future<BaseResponseModel<bool>> changeFan(bool value) async {
    try {
      final payload = {
        'actionCode': value ? 'on' : 'off',
        'deviceId': 'IPhone 15 Pro'
      };
      final res = await _dio.get('mqtt/turn-on-off-fan', data: payload);
      return BaseResponseModel(
        code: res.data['status']['code'],
        message: res.data['status']['message'],
        data: res.data['data'],
      );
    }
    catch(e) {
      print('Error changeFan: $e');
      return BaseResponseModel(
        code: 500,
        message: e.toString(),
        data: false,
      );
    }
  }

  Future<BaseResponseModel<bool>> changeLight(bool value) async {
    try {
      final payload = {
        'actionCode': value ? 'on' : 'off',
        'deviceId': 'IPhone 15 Pro'
      };
      final res = await _dio.get('mqtt/turn-on-off-light', data: payload);
      return BaseResponseModel(
        code: res.data['status']['code'],
        message: res.data['status']['message'],
        data: res.data['data'],
      );
    }
    catch(e) {
      print('Error changeLight: $e');
      return BaseResponseModel(
        code: 500,
        message: e.toString(),
        data: false,
      );
    }
  }

  Future<BaseResponseModel<bool>> changeAirConditioner(bool value) async {
    try {
      final payload = {
        'actionCode': value ? 'on' : 'off',
        'deviceId': 'IPhone 15 Pro'
      };
      final res = await _dio.get('mqtt/turn-on-off-air-condition', data: payload);
      return BaseResponseModel(
        code: res.data['status']['code'],
        message: res.data['status']['message'],
        data: res.data['data'],
      );
    }
    catch(e) {
      print('Error changeAirConditioner: $e');
      return BaseResponseModel(
        code: 500,
        message: e.toString(),
        data: false,
      );
    }
  }
}