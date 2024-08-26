import 'package:bloc/bloc.dart';
import 'package:home_tracking/date_time_utils/param_date.dart';
import 'package:home_tracking/presentation/blocs/bloc_state.dart';
import 'package:home_tracking/presentation/model/action_model.dart';
import 'package:home_tracking/presentation/model/pagination_model.dart';
import 'package:home_tracking/shared/extension/ext_date_time.dart';
import 'package:home_tracking/shared/extension/ext_num.dart';
import 'package:home_tracking/utils/delay_callback.dart';
import 'package:injectable/injectable.dart';

import '../../../repository/action_repository.dart';

@injectable
class ActionBloc extends Cubit<BlocState<List<ActionModel>>> {
  ActionBloc(this._actionRepository) : super(BlocState());

  final ActionRepository _actionRepository;

  PaginationModel? pagination;
  ParamDate? paramDate;

  final DelayCallBack _delayCallBack = DelayCallBack(delay: 500.milliseconds);

  static const int size = 10;
  int page = 0;

  int indexDevice = 0;
  List<DeviceType> devices = DeviceType.values;

  void changeDate(ParamDate paramDate) {
    this.paramDate = paramDate;
    page = 0;
    getData();
  }

  bool _isSort = false;

  bool get isSort => _isSort;

  void sort() {
    _isSort = !_isSort;
    getData();
  }

  String _search = '';

  void setSearch(String search) {
    _delayCallBack.debounce(() {
      _search = search;
      page = 0;
      getData();
    });
  }

  void changeDevice(int? index) {
    indexDevice = index ?? 0;
    page = 0;
    getData();
  }

  void changePage(int page) {
    print('page: $page');
    if (page < 0 || page > pagination!.totalPages - 1) return;
    this.page = page;
    getData();
  }

  Future<void> getData() async {
    emit(state.copyWith(status: Status.loading));
    final res = await _actionRepository.getActions(
      page: page,
      size: size,
      appliance: devices[indexDevice].code,
      search: _search,
      isSort: _isSort,
      startDate: paramDate?.startDate?.formatDefault,
      endDate: paramDate?.endDate?.formatDefault,
    );
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
  airConditioner("air_condition"),
  ;

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
