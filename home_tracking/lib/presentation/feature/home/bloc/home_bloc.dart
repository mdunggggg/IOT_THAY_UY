import 'dart:ffi';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:home_tracking/presentation/model/data_sensor_model.dart';
import 'package:home_tracking/presentation/repository/data_sensor_repo.dart';
import 'package:home_tracking/presentation/repository/mqtt_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../blocs/bloc_state.dart';

@injectable
class HomeBloc extends Cubit<BlocState<List<DataSensorModel>>> {
  HomeBloc(this._dataSensorRepo, this._mqttRepository) : super(BlocState());

  final DataSensorRepo _dataSensorRepo;
  final MqttRepository _mqttRepository;

  List<DataSensorModel> list = [];

  static const int size = 10;
  int _page = 0;

  bool _fan = false;

  bool get fan => _fan;

  bool _light = false;

  bool get light => _light;

  bool _airConditioner = false;

  bool get airConditioner => _airConditioner;

  bool _fanLoading = false;

  bool get fanLoading => _fanLoading;

  bool _lightLoading = false;

  bool get lightLoading => _lightLoading;

  bool _airConditionerLoading = false;

  bool get airConditionerLoading => _airConditionerLoading;

  void add() {
    final last = list.last;
    final newList = list;
    final rnd = Random();
    final newD = DataSensorModel(
      id: last.id! + 1,
      time: last.time! + 15000,
      temperature: rnd.nextDouble() * 100,
      humidity: rnd.nextDouble() * 100,
      light: rnd.nextDouble() * 1024,
    );
    newList.add(newD);
    list = newList;
    emit(state.copyWith(status: Status.success));
  }

  Future<void> setFan(bool value) async {
    _fanLoading = true;
    emit(state.copyWith(status: Status.success));
    await Future.delayed(Duration(seconds: 2));
    _fanLoading = false;
    _fan = value;
    final res = await _mqttRepository.changeFan(value);
    if(res.data == false) {
      _fan = !_fan;
    }
    emit(state.copyWith(status: Status.success));
  }

  Future<void> setLight(bool value) async {
    _lightLoading = true;
    emit(state.copyWith(status: Status.success));
    await Future.delayed(Duration(seconds: 2));
    _lightLoading = false;
    _light = value;
    final res = await _mqttRepository.changeLight(value);
    if(res.data == false) {
      _light = !_light;
    }
    emit(state.copyWith(status: Status.success));
  }
  Future<void> setLight2(bool value) async {
    _light = value;
    print('likkeee $value');
    emit(state.copyWith(status: Status.success));
  }

  Future<void> setAirConditioner(bool value) async {
    _airConditionerLoading = true;
    emit(state.copyWith(status: Status.success));
    await Future.delayed(Duration(seconds: 2));
    _airConditionerLoading = false;
    _airConditioner = value;
    final res = await _mqttRepository.changeAirConditioner(value);
    if(res.data == false) {
      _airConditioner = !_airConditioner;
    }
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
