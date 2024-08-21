import 'package:bloc/bloc.dart';
import 'package:home_tracking/presentation/model/data_sensor_model.dart';
import 'package:home_tracking/presentation/repository/data_sensor_repo.dart';
import 'package:injectable/injectable.dart';

import '../../../blocs/bloc_state.dart';

@injectable
class HomeBloc extends Cubit<BlocState<List<DataSensorModel>>> {
  HomeBloc(this._dataSensorRepo) : super(BlocState());

  final DataSensorRepo _dataSensorRepo;
  List<DataSensorModel> list = [];

  static const int size = 10;
  int _page = 0;

  bool _fan = false;
  bool get fan => _fan;
  bool _light = false;
  bool get light => _light;
  bool _airConditioner = false;
  bool get airConditioner => _airConditioner;

  void setFan(bool value) {
    _fan = value;
    emit(state.copyWith(status: Status.success));
  }

  void setLight(bool value) {
    _light = value;
    emit(state.copyWith(status: Status.success));
  }

  void setAirConditioner(bool value) {
    _airConditioner = value;
    emit(state.copyWith(status: Status.success));
  }

  Future<void> getData() async {
    emit(state.copyWith(status: Status.loading));
    final res = await _dataSensorRepo.getDataSensors(page: _page, size: size);
    list.addAll(res.data ?? []);
    list.sort((a, b) => (a.time ?? 0).compareTo(b.time ?? 0));
    emit(state.copyWith(status: Status.success));
    _page++;
  }
}