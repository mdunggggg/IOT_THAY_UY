import 'dart:math';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_tracking/presentation/blocs/bloc_state.dart';
import 'package:home_tracking/presentation/components/cache_image.dart';
import 'package:home_tracking/presentation/components/loading.dart';
import 'package:home_tracking/presentation/feature/home/bloc/home_bloc.dart';
import 'package:home_tracking/presentation/feature/home/widget/chart_overview.dart';
import 'package:home_tracking/presentation/feature/home/widget/switch_button.dart';
import 'package:home_tracking/shared/extension/ext_num.dart';
import 'package:home_tracking/shared/extension/ext_widget.dart';
import 'package:home_tracking/shared/style_text/style_text.dart';

import '../../../../gen/assets.gen.dart';
import '../../../di/di.dart';
import '../bloc/chart_bloc.dart';
import '../widget/item_overview.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final myBloc = getIt.get<HomeBloc>();
  final chartBloc = getIt.get<ChartBloc>();

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => myBloc..getData(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => chartBloc..getData(),
          lazy: false,
        ),
      ],
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF05231F),
                const Color(0xFF05231F),
                Colors.white,
                Colors.white,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                16.height,
                _buildOverview(),
                16.height,
                _buildChart(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildHeader() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF0A3832),
        borderRadius: 16.radiusBottom,
      ),
      padding: 16.padding,
      child: Center(
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Hello, ",
                    style: StyleApp.medium(fontSize: 24, color: Colors.white),
                    children: [
                      TextSpan(
                        text: "Mạnh Dũng",
                        style: StyleApp.bold(
                            fontSize: 24, color: const Color(0xFFBBD409)),
                      ),
                    ],
                  ),
                ),
                16.height,
                Text("Track your home",
                    style: StyleApp.medium(fontSize: 16, color: Colors.white)),
                Text("Find all the information you need",
                    style: StyleApp.light(fontSize: 12, color: Colors.white)),
              ],
            ).expanded(),
            16.width,
            BaseCacheImage(
              url:
                  "https://ichef.bbci.co.uk/news/976/cpsprodpb/16620/production/_91408619_55df76d5-2245-41c1-8031-07a4da3f313f.jpg",
              borderRadius: 8.radius,
            ).size(height: 100, width: 100)
          ],
        ),
      ),
    );
  }

  _buildOverview() {
    return BlocBuilder<ChartBloc, BlocState>(
      builder: (context, state) {
        if (state.status == Status.loading || chartBloc.list.isEmpty) {
          return BaseLoading();
        }
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: 16.radius,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          margin: 16.padding,
          padding: 16.padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ItemOverview(
                image: Assets.icons.sun.image(height: 25, width: 25),
                title: "Sun light",
                subTitle: "${1024 - chartBloc.list.last.light.validator} lux",
                isUp: 1024 - chartBloc.list.last.light.validator >=
                    1024 - chartBloc.list[max(0, chartBloc.list.length - 2)].light
                        .validator,
              ).expanded(),
              ItemOverview(
                image: Assets.icons.water.image(height: 25, width: 25),
                title: "Humidity",
                subTitle: "${chartBloc.list.last.humidity.validator}%",
                isUp: chartBloc.list.last.humidity.validator >=
                    chartBloc.list[max(0, chartBloc.list.length - 2)].humidity
                        .validator,
              ).expanded(),
              ItemOverview(
                image: Assets.icons.temp.image(height: 25, width: 25),
                title: "Temp",
                subTitle: "${chartBloc.list.last.temperature.validator}°C",
                isUp: chartBloc.list.last.temperature.validator >=
                    chartBloc.list[max(0, chartBloc.list.length - 2)]
                        .temperature.validator,
              ).expanded(),
            ],
          ),
        );
      },
    );
  }

  _buildChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: 16.radius,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: 16.padding,
      padding: 16.padding,
      child: Column(
        children: [
          ChartOverview(
            bloc: chartBloc,
          ),
          16.height,
          BlocBuilder<HomeBloc, BlocState>(
            builder: (context, state) {
              if (state.status == Status.loading) {
                return BaseLoading();
              }
              return Row(
                children: [
                  Column(
                    children: [
                      if (myBloc.light && !myBloc.lightLoading)
                        Assets.icons.lightOn.image(height: 50, width: 50)
                      else if (!myBloc.light && !myBloc.lightLoading)
                        Assets.icons.lightOff.image(height: 50, width: 50)
                      else
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: BaseLoading(),
                        ),
                      SwitchButton(
                          value: myBloc.light,
                          onChanged: myBloc.setLight,
                          isLoading: myBloc.lightLoading),
                    ],
                  ).expanded(),
                  8.width,
                  Column(
                    children: [
                      if (!myBloc.fanLoading)
                        AnimatedBuilder(
                          builder: (context, state) {
                            return Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..rotateZ(_animation.value),
                                child: Assets.icons.fan
                                    .svg(height: 50, width: 50));
                          },
                          animation: _controller,
                        )
                      else
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: BaseLoading(),
                        ),
                      SwitchButton(
                        value: myBloc.fan,
                        onChanged: (value) async {
                          myBloc.setFan(value);
                          if (!value) {
                            _controller.stop();
                          } else {
                            _controller.repeat();
                          }
                        },
                        isLoading: myBloc.fanLoading,
                      ),
                    ],
                  ).expanded(),
                  8.width,
                  Column(
                    children: [
                      if (myBloc.airConditioner &&
                          !myBloc.airConditionerLoading)
                        Assets.icons.airOn.svg(height: 50, width: 50)
                      else if (!myBloc.airConditioner &&
                          !myBloc.airConditionerLoading)
                        Assets.icons.ariOff.svg(height: 50, width: 50)
                      else
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: BaseLoading(),
                        ),
                      SwitchButton(
                        value: myBloc.airConditioner,
                        onChanged: myBloc.setAirConditioner,
                        isLoading: myBloc.airConditionerLoading,
                      ),
                    ],
                  ).expanded(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
