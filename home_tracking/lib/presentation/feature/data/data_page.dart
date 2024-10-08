import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_tracking/presentation/model/data_sensor_model.dart';
import 'package:home_tracking/shared/extension/ext_context.dart';
import 'package:home_tracking/shared/extension/ext_date_time.dart';
import 'package:home_tracking/shared/extension/ext_num.dart';
import 'package:home_tracking/shared/extension/ext_widget.dart';

import '../../../date_time_utils/date_time_widget.dart';
import '../../../date_time_utils/param_date.dart';
import '../../../shared/colors/colors.dart';
import '../../../shared/style_text/style_text.dart';
import '../../blocs/bloc_state.dart';
import '../../components/loading.dart';
import '../../components/table_view.dart';
import '../../constants/colors.dart';
import '../../constants/spacing.dart';
import '../../constants/typography.dart';
import '../../di/di.dart';
import '../home/widget/app_input.dart';
import '../home/widget/empty_container.dart';
import '../home/widget/item_row.dart';
import '../home/widget/select.dart';
import 'bloc/data_bloc.dart';

@RoutePage()
class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  final myBloc = getIt.get<DataBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myBloc..getData(),
      lazy: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF05231F),
          title: Text(
            "Data sensor",
            style: StyleApp.bold(color: Colors.white),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF05231F),
                Color(0xFF05231F),
                Colors.white,
                Colors.white,
              ],
            ),
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              myBloc.page = 0;
              myBloc.getData();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTable(),
                ],
              ),
            ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<DataBloc, BlocState>(
            bloc: myBloc,
            builder: (context, state) {
              return Text("Số lần nhiet do >= 26.2: ${myBloc.solanBatTat}");
            },
          ),
          _buildSearch(),
          16.height,
          _buildDropdown(),
          16.height,
          _buildDropdown2(),
          16.height,
          _buildTime(),
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
              'Tìm kiếm theo: ',
              style: p5.copyWith(fontWeight: BOLD),
            ),
          ),
          Expanded(
            child: CommonDropdown(
              onChanged: myBloc.changeSearch,
              items: List.generate(
                4,
                (index) => DropdownMenuItem(
                  value: index,
                  child: Text(
                    myBloc.searchTypes[index].name,
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

  _buildDropdown2() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: bg_4,
            borderRadius: BorderRadius.circular(sp8),
          ),
          padding: const EdgeInsets.only(left: sp8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Sắp xếp theo: ',
                  style: p5.copyWith(fontWeight: BOLD),
                ),
              ),
              Expanded(
                child: CommonDropdown(
                  onChanged: myBloc.changeProperty,
                  items: List.generate(
                    4,
                    (index) => DropdownMenuItem(
                      value: index,
                      child: Text(
                        myBloc.propertyTypes[index].name,
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
        ).expanded(),
        8.width,
        BlocBuilder<DataBloc, BlocState>(
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
                    color: Colors.grey,
                  ),
                ),
                child: Icon(
                  myBloc.isSort ? Icons.arrow_upward : Icons.arrow_downward,
                  color: Colors.grey,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  _buiLdItems() {
    return BlocBuilder<DataBloc, BlocState<List<DataSensorModel>>>(
      builder: (context, state) {
        if (state.status == Status.loading && state.data == null) {
          return const BaseLoading();
        }
        if(state.data == null || state.data!.isEmpty){
          return const EmptyContainer();
        }
        return TableView(
          headers: ['ID', 'Nhiệt độ', 'Độ ẩm', 'Ánh sáng','Gio', 'Thời gian'],
          data: state.data!.map((e) {
            return [
              e.id.toString(),
              e.temperature?.toString() ?? '',
              e.humidity?.toString() ?? '',
              e.light?.toString() ?? '',
              e.windy.toString() ?? '',
              DateTime.fromMillisecondsSinceEpoch(e.time ?? 0).formatCustom(format: "HH:mm:ss dd/MM/yyyy"),
            ];
          }).toList(),
        );
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
    return BlocBuilder<DataBloc, BlocState<List<DataSensorModel>>>(
      builder: (context, state) {
        if (state.status == Status.success) {
          final data = state.data ?? <DataSensorModel>[];
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

  _itemView(DataSensorModel item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        ItemRow(title: 'Nhiệt độ', value: item.temperature?.toString() ?? ''),
        ItemRow(title: 'Độ ẩm', value: item.humidity?.toString() ?? ''),
        ItemRow(title: 'Ánh sáng', value: item.light?.toString() ?? ''),
        ItemRow(
          title: 'Thời gian',
          value:
          DateTime.fromMillisecondsSinceEpoch(item.time ?? 0).formatCustom(format: "HH:mm:ss dd/MM/yyyy"),
        ),
      ],
    );
  }

  _buildTime() {
    return InkWell(
      onTap: showDateChoose,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(sp12),
          border: Border.all(color: bg_2),
          color: whiteColor,
        ),
        padding: const EdgeInsets.all(sp16),
        child: Row(
          children: [
            const Icon(Icons.date_range_outlined),
            const SizedBox(width: sp8),
            BlocBuilder<DataBloc,
                BlocState>(
              builder: (context, state) {
                var text = '';
                switch (myBloc.paramDate?.dateRange) {
                  case DateRangeEnum.option:
                    text =
                    '${myBloc.paramDate?.startDate?.formatDefault} - ${myBloc.paramDate?.endDate?.formatDefault}';
                    break;
                  default:
                    text = myBloc.paramDate?.dateRange
                        ?.toName ??
                        '';
                    break;
                }
                return Expanded(
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void showDateChoose() {
    context
        .dialog(
      DateTimeWidget(
        param: myBloc.paramDate,
      ),
    )
        .then((value) {
      if (value is ParamDate) {
        myBloc.changeDate(value);
      }
    });
  }
}
