// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:home_tracking/api/dio.dart' as _i771;
import 'package:home_tracking/env/env_config.dart' as _i942;
import 'package:home_tracking/presentation/feature/home/bloc/home_bloc.dart'
    as _i722;
import 'package:home_tracking/presentation/repository/data_sensor_repo.dart'
    as _i295;
import 'package:home_tracking/presentation/router/router.dart' as _i715;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i942.EnvironmentConfig>(() => _i942.EnvironmentConfig());
    gh.factory<_i771.BaseDio>(() => _i771.BaseDio());
    gh.factory<_i715.AppRouter>(() => _i715.AppRouter());
    gh.factory<_i295.DataSensorRepo>(
        () => _i295.DataSensorRepo(gh<_i771.BaseDio>()));
    gh.factory<_i722.HomeBloc>(
        () => _i722.HomeBloc(gh<_i295.DataSensorRepo>()));
    return this;
  }
}
