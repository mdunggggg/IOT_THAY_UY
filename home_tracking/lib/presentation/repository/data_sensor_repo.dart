import 'dart:developer';

import 'package:home_tracking/api/dio.dart';
import 'package:home_tracking/presentation/model/data_sensor_model.dart';
import 'package:home_tracking/presentation/model/pagination_model.dart';
import 'package:injectable/injectable.dart';

import '../model/response.dart';

@injectable
class DataSensorRepo {
  const DataSensorRepo(this._dio);

  final BaseDio _dio;

  Future<BaseResponseModel<List<DataSensorModel>>> getDataSensors({
    int? page,
    int? size,
    String? search,
    String? type,
    String? sortType,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final payload = {
        'page': page,
        'size': size,
        'search': search,
        'type': type,
        'sortType': sortType,
        'startDate': startDate,
        'endDate': endDate,
      };
      payload.removeWhere((key, value) => value == null || value == '');
      final response = await _dio.get("data-sensors/", data: payload);
      final data = (response.data['data']['elements'] as List);
      final List<DataSensorModel> dataSensors =
          data.map((e) => DataSensorModel.fromJson(e)).toList();
      return BaseResponseModel(
          code: response.data['status']['code'],
          message: response.data['status']['message'],
          data: dataSensors,
          extra: PaginationModel(
            page: response.data['data']['page'],
            totalElements: response.data['data']['totalElements'],
            totalPages: response.data['data']['totalPages'],
          ));
    } catch (e) {
      log('Error getDataSensors: $e');
      return BaseResponseModel(code: 500, message: e.toString(), data: []);
    }
  }

  Future<BaseResponseModel<List<DataSensorModel>>> getByLastId({
    int? lastId,
    int? size,
  }) async {
    try {
      final payload = {
        'lastId': lastId,
        'size': size,
      };
      payload.removeWhere((key, value) => value == null || value == '');
      final response = await _dio.get("data-sensors/dashboard", data: payload);
      return BaseResponseModel(
        code: response.data['status']['code'],
        message: response.data['status']['message'],
        data: (response.data['data'] as List)
            .map((e) => DataSensorModel.fromJson(e))
            .toList(),
      );
    }
    catch(e) {
      return BaseResponseModel(code: 500, message: e.toString(), data: []);
    }
  }

  Future<BaseResponseModel> getSolanBatTatQuat() async {
    try {
      final response = await _dio.get('data-sensors/solan-bat-tat-trong-ngay');
      return BaseResponseModel(
          code: response.data['status']['code'],
          message: response.data['status']['message'],
          data: response.data['data']
      );
    }
    catch(e){
      return BaseResponseModel(
          code: 400,
          message: "00",
          data: 0
      );
    }
  }
}
