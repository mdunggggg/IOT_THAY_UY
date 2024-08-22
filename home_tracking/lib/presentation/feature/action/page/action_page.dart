import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_tracking/presentation/components/loading.dart';
import 'package:home_tracking/presentation/feature/action/bloc/action_bloc.dart';
import 'package:home_tracking/presentation/feature/home/widget/app_input.dart';
import 'package:home_tracking/presentation/feature/home/widget/item_row.dart';
import 'package:home_tracking/shared/extension/ext_context.dart';
import 'package:home_tracking/shared/extension/ext_date_time.dart';
import 'package:home_tracking/shared/extension/ext_num.dart';
import 'package:home_tracking/shared/extension/ext_widget.dart';
import 'package:home_tracking/shared/style_text/style_text.dart';

import '../../../../shared/colors/colors.dart';
import '../../../blocs/bloc_state.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../../../model/action_model.dart';
import '../../home/widget/select.dart';

@RoutePage()
class ActionPage extends StatefulWidget {
  const ActionPage({super.key});

  @override
  State<ActionPage> createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
  final myBloc = getIt.get<ActionBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myBloc..getData(),
      lazy: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Action"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildTable(),
            ],
          ),
        ),
      ),
    );
  }

  _buildTable() {
    return Container(
      width: context.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: 16.padding,
      margin: 16.padding,
      child: Column(
        children: [
          _buildSearch(),
          16.height,
          _buildDropdown(),
          16.height,
          _buiLdItems(),
          16.height,
          _buildPaging(),
        ],
      ),
    );
  }

  _buildSearch() {
    return Row(
      children: [
        AppInputSupport(
          hintText: 'Tìm kiếm',
          backgroundColor: Colors.white,
          onChanged: myBloc.setSearch,
          prefixIcon: const Icon(Icons.search_rounded),
        ).expanded(),
        8.width,
        BlocBuilder<ActionBloc, BlocState>(
          builder: (context, state) {
            return InkWell(
              onTap: myBloc.sort,
              child: Container(
                width: sp48,
                height: sp48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(sp8),
                  border: Border.all(
                    color: myBloc.isSort ? Colors.green : Colors.grey,
                  ),
                ),
                child:  Icon(
                  Icons.filter_alt_outlined,
                  color: myBloc.isSort ? Colors.green : Colors.grey,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: bg_4,
        borderRadius: BorderRadius.circular(sp8),
      ),
      padding: const EdgeInsets.only(left: sp8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Loại thiết bị: ',
              style: p5.copyWith(fontWeight: BOLD),
            ),
          ),
          Expanded(
            child: CommonDropdown(
              onChanged: myBloc.changeDevice,
              items: List.generate(
                4,
                (index) => DropdownMenuItem(
                  value: index,
                  child: Text(
                    myBloc.devices[index].name,
                    style: p5,
                  ),
                ),
              ),
              isBorder: false,
              radius: sp8,
              hintText: 'Chọn',
              showIconRemove: false,
              value: 0,
              color: whiteColor,
              borderColor: Colors.grey,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: ColorApp.indigo,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buiLdItems() {
    return BlocBuilder<ActionBloc, BlocState<List<ActionModel>>>(
      builder: (context, state) {
        if (state.status == Status.loading && state.data == null) {
          return const BaseLoading();
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: state.data?.length ?? 0,
          itemBuilder: (context, index) {
            return _itemView(state.data![index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
        );
      },
    );
  }

  _buildPaging() {
    return BlocBuilder<ActionBloc, BlocState<List<ActionModel>>>(
      builder: (context, state) {
        if (state.status == Status.success) {
          final data = state.data ?? <ActionModel>[];
          if (data.isEmpty) {
            return Container();
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  myBloc.changePage(myBloc.page - 1);
                },
                child: Container(
                  width: sp48,
                  height: sp48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp8),
                    border: Border.all(color: borderColor_2),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: blackColor,
                  ),
                ),
              ),
              Text(
                '${myBloc.page + 1}/${myBloc.pagination?.totalPages}',
                style: p5.copyWith(fontWeight: BOLD),
              ),
              InkWell(
                onTap: () {
                  myBloc.changePage(myBloc.page + 1);
                },
                child: Container(
                  width: sp48,
                  height: sp48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp8),
                    border: Border.all(color: borderColor_2),
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: blackColor,
                  ),
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  _itemView(ActionModel item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.deviceId ?? 'Không có dữ liệu',
          style: StyleApp.bold(),
        ),
        8.height,
        ItemRow(title: 'Thiết bị', value: getName(item.appliance ?? '')),
        ItemRow(
          title: 'Thao tác',
          value: getName(item.action ?? ''),
          valueColor: colorText(item.action ?? ''),
        ),
        ItemRow(
            title: 'Thời gian',
            value: DateTime.fromMillisecondsSinceEpoch(item.time ?? 0)
                .formatDefault),
      ],
    );
  }

  String getName(String code) {
    switch (code) {
      case 'light':
        return 'Bóng đèn';
      case 'fan':
        return 'Quạt';
      case 'air-conditioner':
        return "Điều hòa";
      case 'on':
        return 'Bật';
      case 'off':
        return 'Tắt';
      default:
        return 'Unknown';
    }
  }

  Color colorText(String code) {
    switch (code) {
      case 'on':
        return Colors.green;
      case 'off':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
