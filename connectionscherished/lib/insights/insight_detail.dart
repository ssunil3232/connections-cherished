import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/navigation/top_nav_bar_widget.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InsightDetail extends StatefulWidget {
  const InsightDetail({super.key, required this.friend});

  final FriendModel friend;
  @override
  InsightDetailState createState() => InsightDetailState();
}

class InsightDetailState extends State<InsightDetail> {
  
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
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBarWidget(
        showBorder: false,
        height: 100.0,
        header: Text(widget.friend.name ?? 'Insight details', style: GlobalStyles.textStyles.titleHeader),
        showBackButton: true,
      ),
      body: PagePadding(
        bottomPadding: GlobalStyles.spacingStates.spacing32,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: GlobalStyles.spacingStates.spacing40),
              RichText(
                text: TextSpan(
                  children:[
                    TextSpan(
                      text: "Toggle through time and watch your journey with ${widget.friend.name} unfold!",
                      style: GlobalStyles.textStyles.textBody
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.only(left: GlobalStyles.spacingStates.spacing8),
                        child: SvgPicture.asset('assets/icons/rocket_icon.svg', width: 24, height: 24),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: GlobalStyles.spacingStates.spacing40),
              Column(
                children: [
                  // Row(
                  //   children: [
                  //     Text('You have', style: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.textSubtle),),
                  //     Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.spacing12),
                  //       child: Container(
                  //         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  //         decoration: BoxDecoration(
                  //           color: GlobalStyles.btnBgTertiary,
                  //           borderRadius: BorderRadius.circular(GlobalStyles.spacingStates.spacing16),
                  //         ),
                  //         child: Text(
                  //           '${journalEntries.length}',
                  //           style: GlobalStyles.textStyles.textH1,
                  //         ),
                  //       ),
                  //     ),
                  //     Text('journal entries', style: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.textSubtle),),
                  //   ],
                  // ),
                ]
              ),
            ]
          )
        )
    );
  }
}