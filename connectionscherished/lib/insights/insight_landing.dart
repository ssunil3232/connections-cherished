import 'package:connectionscherished/insights/guange_indicator.dart';
import 'package:connectionscherished/insights/insight_detail.dart';
import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/services/user_service.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/navigation/top_nav_bar_widget.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:connectionscherished/widgets/premium_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class InsightLanding extends StatefulWidget {
  const InsightLanding({super.key});
  @override
  InsightLandingState createState() => InsightLandingState();
}

class InsightLandingState extends State<InsightLanding> {
  final _userService = GetIt.I.get<UserService>();
  List<FriendModel> connections = [];
  bool isSubscribed = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadData() {
    getConnections();
    setState(() {
    });
  }

  Future<void> getConnections() async {
    try {
      connections = await _userService.getFriends();
      if (connections.isNotEmpty) {
        connections.sort(
            (a, b) => b.calculatePriorityScore().compareTo(a.calculatePriorityScore()));
      }
      setState(() {
        isSubscribed = connections.isEmpty;
      });
    } catch (e) {
      Exception('Error fetching connections: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBarWidget(
        showBorder: false,
        height: 100.0,
        header: Text("Insights", style: GlobalStyles.textStyles.titleHeader),
        showBackButton: true,
      ),
      body: Stack(
        children: [
          // Main scrollable content (without noConnections)
          AbsorbPointer(
            absorbing: !isSubscribed,
            child: SingleChildScrollView(
              physics: isSubscribed
                  ? const BouncingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: PagePadding(
                  bottomPadding: GlobalStyles.spacingStates.spacing32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: GlobalStyles.spacingStates.spacing40),
                      Text(
                        "Let’s see how well you’ve fared in cherishing your connections!",
                        style: GlobalStyles.textStyles.textBody,
                      ),
                      ArcGauge(percentage: connections.isNotEmpty ? 0.7 : 0),
                      if (connections.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(
                              top: GlobalStyles.spacingStates.spacing32),
                          child: InsightDetail(connections: connections),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Position noConnections at the bottom when there are no connections.
          if (connections.isEmpty)
            Align(
              alignment: Alignment.bottomCenter,
              child: noConnections(),
            ),
          // Bottom overlay for premium call-to-action if not subscribed.
          if (!isSubscribed)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.transparent,
                      Colors.white,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: GlobalStyles.spacingStates.spacing20,
                        horizontal: GlobalStyles.spacingStates.spacing24,
                      ),
                      child: CustomButtonWidget.secondary(
                        customIcon: Image.asset(
                          'assets/icons/unlock_icon.gif',
                          width: 30,
                          height: 30,
                        ),
                        text: 'Unlock premium now!',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => PremiumDialogWidget(
                              onResponse: (value) {
                                if (value) {
                                  setState(() {
                                    isSubscribed = true;
                                  });
                                }
                              },
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget noConnections(){
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              color: GlobalStyles.defaultTextBg,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(
              vertical: GlobalStyles.spacingStates.spacing44,
              horizontal: GlobalStyles.spacingStates.spacing60,
            ),
            child: Text(
              "No connection streaks yet!",
              textAlign: TextAlign.center,
              style: GlobalStyles.textStyles.textBody.copyWith(
                color: GlobalStyles.textSubtle,
              ),
            ),
          ),
          SizedBox(height: GlobalStyles.spacingStates.spacing40),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Start by adding a ',
                  style: GlobalStyles.textStyles.textBody,
                ),
                TextSpan(
                  text: 'connection!',
                  style: GlobalStyles.textStyles.textH3Varaint,
                ),
              ],
            ),
          ),
          SizedBox(height: GlobalStyles.spacingStates.spacing24),
          Image.asset(
            'assets/images/logo.png',
            width: 146,
            height: 140,
          ),
          SizedBox(height: GlobalStyles.spacingStates.spacing40),
        ],
      ),
    );
  }
}