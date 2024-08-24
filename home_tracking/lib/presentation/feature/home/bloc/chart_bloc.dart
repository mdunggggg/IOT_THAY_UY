import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:home_tracking/presentation/blocs/bloc_state.dart';
import 'package:home_tracking/presentation/repository/data_sensor_repo.dart';
import 'package:injectable/injectable.dart';

import '../../../model/data_sensor_model.dart';

@injectable
class ChartBloc extends Cubit<BlocState> {
  ChartBloc(this._repo) : super(BlocState());

  final DataSensorRepo _repo;

  final List<DataSensorModel> list = [];
  bool isFirstTime = true;

  Future<void> getData() async {
    final res = await _repo.getByLastId(size: isFirstTime ? null : 10, lastId: list.isNotEmpty ? list.last.id : null);
    if (res.code == 200) {
      if(isFirstTime) {
       List<DataSensorModel> data = res.data ?? [] ;
        isFirstTime = false;
        data.removeRange(0, max(0, data.length - 10));
        list.addAll(data);
      }
      else {
        list.addAll(res.data ?? []);
      }
      emit(state.copyWith(status: Status.success));
    } else {
      emit(state.copyWith(status: Status.error, msg: res.message));
    }
  }


}
