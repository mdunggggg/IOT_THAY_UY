import 'package:bloc/bloc.dart';
import 'package:home_tracking/presentation/blocs/bloc_state.dart';
import 'package:home_tracking/presentation/model/data_sensor_model.dart';
import 'package:home_tracking/presentation/model/pagination_model.dart';
import 'package:home_tracking/presentation/repository/data_sensor_repo.dart';
import 'package:home_tracking/shared/extension/ext_date_time.dart';
import 'package:home_tracking/shared/extension/ext_num.dart';
import 'package:home_tracking/utils/delay_callback.dart';
import 'package:injectable/injectable.dart';

import '../../../../date_time_utils/param_date.dart';

@injectable
class DataBloc extends Cubit<BlocState<List<DataSensorModel>>> {
  DataBloc(this._repo) : super(BlocState());

  final DataSensorRepo _repo;
  PaginationModel? pagination;
  ParamDate? paramDate = ParamDate();

  bool _isSort = false;

  bool get isSort => _isSort;

  final DelayCallBack _delayCallBack = DelayCallBack(delay: 500.milliseconds);

  static const int size = 10;
  int page = 0;

  int indexSearch = 0;
  List<SearchType> searchTypes = SearchType.values;

  String _search = '';
  void setSearch(String search) {
    _delayCallBack.debounce(() {
      _search = search;
      page = 0;
      getData();
    });
  }

  void changeDate(ParamDate paramDate) {
    this.paramDate = paramDate;
    page = 0;
    getData();
  }


  void changeSearch(int? index) {
    indexSearch = index ?? 0;
    page = 0;
    getData();
  }

  int indexProperty = 0;
  List<PropertyType> propertyTypes = PropertyType.values;
  void changeProperty(int? index) {
    indexProperty = index ?? 0;
    page = 0;
    getData();
  }

  void sort() {
    _isSort = !_isSort;
    getData();
  }

  void changePage(int page) {
    if (page < 0 || page > pagination!.totalPages - 1) return;
    this.page = page;
    getData();
  }

  Future<void> getData() {
    emit(state.copyWith(status: Status.loading));
    return _repo.getDataSensors(
      page: page,
      size: size,
      search: _search,
      type: searchTypes[indexSearch].code,
      sortType: !_isSort ? '-${propertyTypes[indexProperty].code}' : propertyTypes[indexProperty].code,
      startDate: paramDate?.startDate?.formatDefault,
      endDate: paramDate?.endDate?.formatDefault,
    ).then((res) {
      if (res.code == 200) {
        pagination = res.extra;
        emit(state.copyWith(status: Status.success, data: res.data));
      } else {
        emit(state.copyWith(status: Status.error, msg: res.message));
      }
    });

  }

}

enum PropertyType {
  time("time"),
  temperature("temp"),
  humidity("humidity"),
  light("light");
  const PropertyType(this.code);

  final String code;
}

extension PropertyTypeExtension on PropertyType {
  String get name {
    switch (this) {
      case PropertyType.temperature:
        return 'Nhiệt độ';
      case PropertyType.humidity:
        return 'Độ ẩm';
      case PropertyType.light:
        return 'Ánh sáng';
      case PropertyType.time:
        return 'Thời gian';
    }
  }
}

enum SearchType {
  all,
  temperature,
  humidity,
  light,
}

extension SearchTypeExtension on SearchType {
  String get name {
    switch (this) {
      case SearchType.all:
        return 'Tất cả';
      case SearchType.temperature:
        return 'Nhiệt độ';
      case SearchType.humidity:
        return 'Độ ẩm';
      case SearchType.light:
        return 'Ánh sáng';
    }
  }

  String get code {
    switch (this) {
      case SearchType.all:
        return 'all';
      case SearchType.temperature:
        return 'temp';
      case SearchType.humidity:
        return 'humidity';
      case SearchType.light:
        return 'light';
    }
  }
}
