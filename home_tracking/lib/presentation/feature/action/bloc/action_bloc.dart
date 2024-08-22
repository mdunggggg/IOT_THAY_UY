import 'package:bloc/bloc.dart';
import 'package:home_tracking/presentation/blocs/bloc_state.dart';
import 'package:home_tracking/presentation/model/action_model.dart';
import 'package:home_tracking/presentation/model/pagination_model.dart';
import 'package:injectable/injectable.dart';

import '../../../repository/action_repository.dart';

@injectable
class ActionBloc extends Cubit<BlocState<List<ActionModel>>> {
  ActionBloc(this._actionRepository) : super(BlocState());

  final ActionRepository _actionRepository;

  PaginationModel? pagination;

  static const int size = 10;
  int page = 0;

  int indexDevice = 0;
  List<DeviceType> devices = DeviceType.values;

  void changeDevice(int? index) {
    indexDevice = index ?? 0;
    page = 0;
    getData();
  }

  void changePage(int page) {
    print('page: $page');
    if(page < 0 || page > pagination!.totalPages - 1) return;
    this.page = page;
    getData();
  }

  Future<void> getData() async {
    emit(state.copyWith(status: Status.loading));
    final res = await _actionRepository.getActions(page: page, size: size);
    if (res.code == 200) {
      pagination = res.extra;
      emit(state.copyWith(status: Status.success, data: res.data));
    } else {
      emit(state.copyWith(status: Status.error, msg: res.message));
    }
  }
}

enum DeviceType {
  all(""),
  light("light"),
  fan("fan"),
  airConditioner("air_conditioner"),;

  const DeviceType(this.code);
  final String code;
}

extension DeviceExt on DeviceType {
  String get name {
    switch (this) {
      case DeviceType.light:
        return "Bóng đèn";
      case DeviceType.fan:
        return "Quạt";
      case DeviceType.airConditioner:
        return "Điều hòa";
      default:
        return "Tất cả";
    }
  }
}