import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_tracking/presentation/components/cache_image.dart';
import 'package:home_tracking/shared/extension/ext_num.dart';
import 'package:home_tracking/shared/extension/ext_widget.dart';
import 'package:home_tracking/shared/style_text/style_text.dart';

import '../../../../gen/assets.gen.dart';
import '../widget/item_overview.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            16.height,
            _buildOverview(),
          ],
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
            title: "Sun light",
            subTitle: "10%",
          ).expanded(),
          ItemOverview(
            image: Assets.icons.temp.image(height: 25, width: 25),
            title: "Sun light",
            subTitle: "24°C",
          ).expanded(),
        ],
      ),
    );
  }
}
