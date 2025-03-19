import 'package:connectionscherished/models/timezone_model.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/form-fields/input_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:azlistview/azlistview.dart';
import 'package:smooth_corner/smooth_corner.dart';

// ignore: must_be_immutable
class TimezoneListPage extends StatefulWidget {
  final List<TimezoneModel> formattedTimezones;
  Function(String) selectedTimezone;
  TimezoneListPage({super.key, required this.formattedTimezones, required this.selectedTimezone});

  @override
  TimezoneListPageState createState() => TimezoneListPageState();
}

class TimezoneListPageState extends State<TimezoneListPage> {
  List<TimezoneModel> filteredTimezones = [];
  String _searchText = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadData();
  }

  /// Prepares the list by sorting it by cityName and assigning each item's tag
  /// as the uppercase first letter of the city name.
  void _prepareTimezoneList(List<TimezoneModel> list) {
    // Sort by cityName alphabetically
    list.sort((a, b) => a.cityName.compareTo(b.cityName));
    for (final item in list) {
      final city = item.cityName;
      // Use the first letter of the city name (uppercase) as the tag.
      item.tag = city.isNotEmpty ? city[0].toUpperCase() : '#';
    }
    SuspensionUtil.sortListBySuspensionTag(list);
    SuspensionUtil.setShowSuspensionStatus(list);
  }

  Future<void> _loadData() async {
    setState(() {
      filteredTimezones = List.from(widget.formattedTimezones);
      _prepareTimezoneList(filteredTimezones);
    });
  }

  /// Filter based on the search text
  void _onSearchChanged() {
    setState(() {
      _searchText = _searchController.text;
      if (_searchText.isEmpty) {
        filteredTimezones = List.from(widget.formattedTimezones);
      } else {
        filteredTimezones = widget.formattedTimezones.where((timezone) {
          return timezone.location
              .replaceAll('_', ' ')
              .toLowerCase()
              .contains(_searchText.toLowerCase());
        }).toList();
      }
      // Re-prepare the filtered list for grouping.
      _prepareTimezoneList(filteredTimezones);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1.0,
      heightFactor: 0.95,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            top: 100,
            child: _scrollableList()
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SmoothContainer(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30.0),
              ),
              height: 100,
              color: GlobalStyles.defaultBg,
              child: Column(
                mainAxisSize: MainAxisSize.min, 
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing16),
                    child: Text(
                      'Choose a Timezone',
                      style: GlobalStyles.textStyles.textCaption1.copyWith(
                        color: GlobalStyles.textSubtle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InputFieldWidget(
                      controller: _searchController,
                      placeholderText: 'Search a city',
                      prefixIcon: const Icon(Icons.search),
                      verticalPadding: 4,
                    ),
                  ),
                ],
              ),
            ),
          )
        ]
      )
    );
  }


  Widget _scrollableList(){
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: AzListView(
        susItemHeight: 30,
        hapticFeedback: true,
        data: filteredTimezones,
        itemCount: filteredTimezones.length,
        itemBuilder: (context, index) {
          final timezone = filteredTimezones[index];
          return ListTile(
            dense: true,
            minVerticalPadding: 0,
            minTileHeight: 0,
            contentPadding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.spacing12, horizontal: GlobalStyles.spacingStates.spacing16),
            title: Text(
              timezone.location.replaceAll('_', ' '),
              style: GlobalStyles.textStyles.textBody,
            ),
            subtitle: Text(
              'UTC ${timezone.offset_hours}',
              style: GlobalStyles.textStyles.textCaption2.copyWith(
                color: GlobalStyles.textSubtle,
              ),
            ),
            enabled: true,
            onTap: () {
              widget.selectedTimezone(timezone.location);
              // Handle tap (e.g., return the selected timezone)
              Navigator.pop(context);
            },
          );
        },
        susItemBuilder: (context, index) {
          final tag = filteredTimezones[index].getSuspensionTag();
          return _buildHeader(tag);
        },
        // Provides the index data for the side index bar.
        indexBarData: SuspensionUtil.getTagIndexList(filteredTimezones),
        indexBarWidth: 40,
        indexBarItemHeight: 20,
        indexBarOptions: IndexBarOptions(
          needRebuild: true,
          selectTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          selectItemDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: GlobalStyles.defaultBorderEnabled,
          ),
        ),
      ),
    );
  }

  /// Builds the header widget for each section.
  Widget _buildHeader(String tag) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: GlobalStyles.btnBgSecondary,
      alignment: Alignment.centerLeft,
      child: Text(
        tag,
        style: GlobalStyles.textStyles.textCaption1.copyWith(
          color: GlobalStyles.textSubtle,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}
