import 'package:get_it/get_it.dart';
import 'package:home_tracking/presentation/di/di.config.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
