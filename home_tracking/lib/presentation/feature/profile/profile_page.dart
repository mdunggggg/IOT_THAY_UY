import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:home_tracking/presentation/feature/home/widget/item_row.dart';
import 'package:home_tracking/shared/extension/ext_num.dart';
import 'package:home_tracking/shared/extension/ext_widget.dart';

import '../../../gen/assets.gen.dart';
import '../../../shared/style_text/style_text.dart';
import '../../components/cache_image.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white,
              const Color(0xFF05231F),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: const Color(0xFF0A3832),
                  borderRadius: 32.radiusBottom,
                ),
                child: Stack(
                  children: [
                    Assets.images.bgStart.image(
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BaseCacheImage(
                            url:
                                "https://ichef.bbci.co.uk/news/976/cpsprodpb/16620/production/_91408619_55df76d5-2245-41c1-8031-07a4da3f313f.jpg",
                            borderRadius: 16.radius,
                          ).size(height: 100, width: 100),
                          16.height,
                          Text(
                            "Hoàng Mạnh Dũng",
                            style:
                                StyleApp.bold(fontSize: 24, color: Colors.white),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Transform(
                transform: Matrix4.translationValues(0.0, -48, 0.0),
                child: _buildOverview(),
              ),
              _buildProject(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverview() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: 16.radius,
      ),
      padding: 16.padding,
      margin: 36.paddingHor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Thông tin cá nhân",
              style: StyleApp.bold(fontSize: 16, color: Colors.black)),
          16.height,
          const ItemRow(title: "Mã SV:", value: "B21DCCN268"),
          const ItemRow(title: "Lớp chính quy:", value: "D21CQCN04-B"),
          const ItemRow(title: "Lớp chuyên ngành: ", value: "D21CNPM2"),
          const ItemRow(title: "Email:", value: "dungmanh74@gmail.com"),
        ],
      ),
    );
  }

  _buildProject() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: 16.radius,
      ),
      padding: 16.padding,
      margin: 36.paddingHor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Dự án",
              style: StyleApp.bold(fontSize: 16, color: Colors.black)),
          16.height,
          const ItemRow(title: "Tên dự án:", value: "Home Tracking"),
          const ItemRow(title: "Thành viên:", value: "Hoàng Mạnh Dũng"),
          const ItemRow(title: "Github", value: "mdunggggg"),
        ],
      ),
    );
  }
}
