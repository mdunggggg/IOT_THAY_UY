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
    return BlocProvider(
      create: (context) => myBloc..getData(),
      lazy: false,
      child: Scaffold(
        body: SingleChildScrollView(
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
    return BlocBuilder<HomeBloc, BlocState>(
      builder: (context, state) {
        if (state.status == Status.loading) {
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
            children: [
              ItemOverview(
                image: Assets.icons.temp.image(height: 25, width: 25),
                title: "Sun light",
                subTitle: "High",
              ).expanded(),
              ItemOverview(
                image: Assets.icons.water.image(height: 25, width: 25),
                title: "Humidity",
                subTitle: "${myBloc.list.last.humidity.validator}%",
              ).expanded(),
              ItemOverview(
                image: Assets.icons.temp.image(height: 25, width: 25),
                title: "Temp",
                subTitle: "${myBloc.list.last.temperature.validator}°C",
              ).expanded(),
            ],
          ),
        );
      },
    );
  }

  _buildChart() {
    return BlocBuilder<HomeBloc, BlocState>(
      builder: (context, state) {
        if (state.status == Status.loading) {
          return const BaseLoading();
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
          child: Column(
            children: [
              ChartOverview(list: myBloc.list),
              16.height,
              Row(
                children: [
                  Column(
                    children: [
                      if (myBloc.light)
                        Assets.icons.lightOn.image(height: 50, width: 50)
                      else
                        Assets.icons.lightOff.image(height: 50, width: 50),
                      SwitchButton(
                          value: myBloc.light, onChanged: myBloc.setLight),
                    ],
                  ).expanded(),
                  8.width,
                  Column(
                    children: [
                      AnimatedBuilder(
                        builder: (context, state) {
                          return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..rotateZ(_animation.value),
                              child:
                                  Assets.icons.fan.svg(height: 50, width: 50));
                        },
                        animation: _controller,
                      ),
                      SwitchButton(value: myBloc.fan, onChanged: (value) async {
                            myBloc.setFan(value);
                        // stop animation
                        if (!value) {
                          _controller.stop();
                        } else {
                          _controller.repeat();
                        }
                      }),
                    ],
                  ).expanded(),
                  8.width,
                  Column(
                    children: [
                      if (myBloc.airConditioner)
                        Assets.icons.airOn.svg(height: 50, width: 50)
                      else
                        Assets.icons.ariOff.svg(height: 50, width: 50),
                      SwitchButton(
                          value: myBloc.airConditioner,
                          onChanged: myBloc.setAirConditioner),
                    ],
                  ).expanded(),
                ],
              ),
              OutlinedButton(onPressed: myBloc.add, child: Text("Add")),
            ],
          ),
        );
      },
    );
  }
}
