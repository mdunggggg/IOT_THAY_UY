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

  Future<void> getData() async {
    emit(state.copyWith(status: Status.loading));
    final res = await _dataSensorRepo.getDataSensors(page: _page, size: size);
    list.addAll(res.data ?? []);
    emit(state.copyWith(status: Status.success));
    _page++;
  }
}