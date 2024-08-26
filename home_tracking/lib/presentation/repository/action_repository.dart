import 'dart:developer';

import 'package:home_tracking/api/dio.dart';
import 'package:injectable/injectable.dart';

import '../model/action_model.dart';
import '../model/pagination_model.dart';
import '../model/response.dart';

@injectable
class ActionRepository {
  ActionRepository(this._dio);

  final BaseDio _dio;

  Future<BaseResponseModel<List<ActionModel>>> getActions({
    int? page,
    int? size,
    String? appliance,
    String? device,
    String? search,
    bool? isSort,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final payload = {
        'page': page,
        'size': size,
        'appliance': appliance,
        'device': device,
        'search': search,
        'startDate': startDate,
        'endDate': endDate,
        'sort': isSort == null ? null : isSort ? 'asc' : 'desc',
      };
      print('payload: $payload');
      payload.removeWhere((key, value) => value == null || value == '');
      final response = await _dio.get('actions/', data: payload);
      final data = (response.data['data']['elements'] as List);
      final List<ActionModel> actionModel =
          data.map((e) => ActionModel.fromJson(e)).toList();
      return BaseResponseModel(
          code: response.data['status']['code'],
          message: response.data['status']['message'],
          data: actionModel,
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
}
