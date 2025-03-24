import 'package:connectionscherished/insights/charts/bar_chart.dart';
import 'package:connectionscherished/insights/charts/linear_chart.dart';
import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/services/util_service.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/cached_image_widget.dart';
import 'package:connectionscherished/widgets/form-fields/dropdown_widget.dart';
import 'package:connectionscherished/widgets/toggle_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:smooth_corner/smooth_corner.dart';

enum ChartType { week, month, year }

// ignore: must_be_immutable
class InsightDetail extends StatefulWidget {
  InsightDetail({super.key, required this.connections});
  List<FriendModel> connections = [];
  @override
  InsightDetailState createState() => InsightDetailState();
}

class InsightDetailState extends State<InsightDetail> {
  ChartType selectedChartType = ChartType.week;
  Map<String,dynamic> data = {};
  final _utilService = GetIt.I.get<UtilService>();
  String friendId = "all";
  List<DropdownItems> dropdownItems = [
    DropdownItems(value: "all", label: "all", enabledButton: true)
  ];
  
  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadData() async {
    data = await _utilService.getAnalytics(widget.connections[0].userId ?? '');
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children:[
              TextSpan(
                text: "Toggle through time and watch your journey with your connections unfold!",
                style: GlobalStyles.textStyles.textBody
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: EdgeInsets.only(left: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing8, useWidth: true)),
                  child: SvgPicture.asset('assets/icons/rocket_icon.svg', width: GlobalStyles.spacingStates.iconSize, height: GlobalStyles.spacingStates.iconSize),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing12)),
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if(friendId != "all")
              CachedImageWidget(
                height: GlobalStyles.spacingStates.imageThumbnailEnlarged, 
                width: GlobalStyles.spacingStates.imageThumbnailEnlarged, 
                imageUrlProvided: widget.connections.firstWhere((element) => element.friendId == friendId).profileImage
              ), 
              Padding(
                padding: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing8, useWidth: true)),
                child: CustomDropdownWidget(
                  disabled: false,
                  placeholderText: 'Select a friend',
                  onChanged:(value) {
                    setState(() {
                      friendId = value;
                    });
                  }, 
                  dropdownItems: widget.connections.map((FriendModel friend){
                    return DropdownItems(
                      value: friend.friendId ?? "",
                      label: friend.name ?? "",
                      enabledButton: true
                    );
                  }).toList()..insert(0, DropdownItems(value: "all", label: "All", enabledButton: true)),
                  initialValue: friendId,
                  menuWidth: MediaQuery.of(context).size.width * 0.4,
                  menuHeight: 200,
                  buttonWidth: MediaQuery.of(context).size.width * 0.4,
                  buttonHeight: 45,
                ),
              ),
            ]
          )
        ),
        SizedBox(height: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing20)),
        Column(
          children: [
            SmoothContainer(
              borderRadius: BorderRadius.circular(GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing20)),
              smoothness: 1,
              height: 200,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing8, useWidth: true)),
              color: const Color.fromARGB(255, 26, 26, 26),
              child: selectedChartType == ChartType.week ? 
                WeeklyChart(
                  data: data["all"]?["week"] ?? {},
                  friendData: friendId == "all" ? null : (data[friendId]?["week"] ?? {}),
                ) :
                LinearChart(
                  selectedChartType: selectedChartType,
                  data: data["all"]?[selectedChartType == ChartType.month ? "month" : "year"] ?? {},
                  friendData: friendId == "all" ? null : (data[friendId]?[selectedChartType == ChartType.month ? "month": "year"] ?? {}),
                ),
            ),
            SizedBox(height: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing12)),
            ToggleButtonWidget(
              onToggle: (int value) {
                setState(() {
                  selectedChartType = ChartType.values[value];
                  loadData();
                });
              },
            ),
          ]
        ),
      ]
    );
  }
}