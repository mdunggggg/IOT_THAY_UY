import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:home_tracking/presentation/blocs/bloc_state.dart';
import 'package:home_tracking/presentation/repository/action_repository.dart';
import 'package:home_tracking/presentation/repository/data_sensor_repo.dart';
import 'package:home_tracking/presentation/repository/mqtt_repository.dart';
import 'package:home_tracking/shared/extension/ext_num.dart';
import 'package:injectable/injectable.dart';

import '../../../model/data_sensor_model.dart';

@injectable
class ChartBloc extends Cubit<BlocState> {
  ChartBloc(this._repo, this._repoaction) : super(BlocState());

  final DataSensorRepo _repo;
  final MqttRepository _repoaction;

  final List<DataSensorModel> list = [];
  bool isChange = false;
  int count = 0;
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
        final last = list.last.windy ?? 0;
        print('=====> last ');
        isChange = last >= 50;
        if (last >= 50) {
          final res = await _repoaction.changeLight(true);
          print('');
        }
        else {
          final res = await _repoaction.changeLight(false);
        }
      }
      emit(state.copyWith(status: Status.success));
    } else {
      emit(state.copyWith(status: Status.error, msg: res.message));
    }
  }


}
