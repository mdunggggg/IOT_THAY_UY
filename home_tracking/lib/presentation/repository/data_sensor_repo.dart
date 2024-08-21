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

  Future<BaseResponseModel<List<DataSensorModel>>> getDataSensors(
      {int? page, int? size}) async {
    try {
      final payload = {
        'page': page,
        'size': size,
      };
      payload.removeWhere((key, value) => value == null);
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
        )
      );
    } catch (e) {
      log('Error getDataSensors: $e');
      return BaseResponseModel(code: 500, message: e.toString(), data: null);
    }
  }
}
