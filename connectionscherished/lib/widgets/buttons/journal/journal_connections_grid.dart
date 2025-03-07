import 'package:connectionscherished/journals/journal_entries.dart';
import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class JournalsConnectionGrid extends StatefulWidget {
  const JournalsConnectionGrid({super.key, required this.data});
  final List<FriendModel> data;

  @override
  _JournalsConnectionGridState createState() => _JournalsConnectionGridState();
}

class _JournalsConnectionGridState extends State<JournalsConnectionGrid> {

  @override
  void initState() {
    super.initState();
  }

  void viewJournals(FriendModel item) {
    // navigate to journal detail
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalEntries(friend: item)
      ),
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
              onTap: ()=> viewJournals(item),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: GlobalStyles.btnBgTertiary,
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
