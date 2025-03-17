import 'package:connectionscherished/insights/insight_detail.dart';
import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/cached_image_widget.dart';
import 'package:connectionscherished/widgets/premium_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class InsightsConnectionGrid extends StatefulWidget {
  const InsightsConnectionGrid({super.key, required this.data});
  final List<FriendModel> data;

  @override
  InsightsConnectionGridState createState() => InsightsConnectionGridState();
}

class InsightsConnectionGridState extends State<InsightsConnectionGrid> {

  @override
  void initState() {
    super.initState();
  }

  void viewInsightDetail(FriendModel item) {
    // navigate to viewInsightDetail
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return PremiumDialogWidget(
          onResponse: (value){
            if (value) {
              // Should show payment plan
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InsightDetail(friend: item)
                ),
              );
            }
          },
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: List.generate(widget.data.length, (i) {
            final item = widget.data[i];
            return GestureDetector(
              onTap: ()=> viewInsightDetail(item),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: GlobalStyles.btnBgSecondary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CachedImageWidget(
                      height: 44, 
                      width: 44, 
                      imageUrlProvided: item.profileImage
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.spacing16),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 100),
                              child: Text(
                                item.name ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: GlobalStyles.textStyles.textButtonSecondary,
                              ),
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: GlobalStyles.spacingStates.spacing12),
                            child: VariedIcon.varied(Symbols.arrow_forward_ios_rounded,)
                          )
                        ],
                      )
                    )
                  ],
                ),
              )
            );
          }),
        ),
      )
    );
  }
}
