import 'package:connectionscherished/journals/journal_entry.dart';
import 'package:connectionscherished/models/journal_model.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class JournalGridItem extends StatefulWidget {
  const JournalGridItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.data,
    required this.onCollapse,
    required this.onDelete,
    required this.onUpdate
  });

  final String title;
  final String subtitle;
  final Color color;
  final JournalModel data;
  final VoidCallback onCollapse;
  final VoidCallback onUpdate;
  final Function (JournalModel) onDelete;

  @override
  State<JournalGridItem> createState() => JournalGridItemState();
}

class JournalGridItemState extends State<JournalGridItem> {
  bool isCollapsed = false;
  bool showText = true;

  void toggleExpansion() {
    setState(() {
      isCollapsed = !isCollapsed;
      if (isCollapsed) {
        widget.onCollapse();
        showText = false;
      } else {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            setState(() {
              showText = true;
            });
          }
        });
      }
    });
  }

  void expand() {
    setState(() {
      isCollapsed = false;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          showText = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleExpansion,
      child: SizedBox(
        height: 44,
        child: Stack(
          children: [
            _gridActionsLayer(),
            _gridContentLayer(),
          ]
        )
      )
    );
  }

  Future<void> deleteJournalEntry () async {
    widget.onUpdate();
    widget.onDelete(widget.data);
  }

  Widget _gridActionsLayer(){
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Color(0xFF4E4C4C),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                    JournalEntry(
                      journal: widget.data, 
                      type: JournalEntryType.edit,
                      onUpdate: widget.onUpdate
                    )
                ),
              );
            },
            icon: SvgPicture.asset(
              'assets/icons/edit_icon.svg', 
              color: Colors.white,
              width: 24, 
              height: 24
            ),//Icon(Icons.edit, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              // Delete action
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogWidget(
                    header: null,
                    image: Image.asset(
                      "assets/images/concerned-face.png",
                      width: 150,
                      height: 150,
                    ),
                    descriptions: const ["Are you sure you want to\ndelete this journal entry?"],
                    confirmTitle: "No, let’s keep it",
                    cancelTitle: "Yes, let’s delete",
                    onResponse: (value){
                      !value ? deleteJournalEntry() : null;
                    },
                    // isWarning: true,
                  );
                }
              );
            },
            icon: SvgPicture.asset(
              'assets/icons/delete_icon.svg', 
              color: Colors.white,
              width: 24, 
              height: 24
            ), //VariedIcon.varied(Symbols.delete_outline_rounded, color: Colors.white),//Icon(Icons.delete, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              // View action
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                    JournalEntry(
                      journal: widget.data, 
                      type: JournalEntryType.view,
                      onUpdate: widget.onUpdate
                    )
                ),
              );
            },
            icon: SvgPicture.asset(
              'assets/icons/view_icon.svg', 
              color: Colors.white,
              width: 24, 
              height: 24
            ), //Icon(Icons.remove_red_eye, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _gridContentLayer(){
    double fullWidth = MediaQuery.of(context).size.width;
    double shrinkWidth = fullWidth * 0.55;
    return ClipRect(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: isCollapsed ? shrinkWidth : fullWidth,
        height: 44,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.spacing16),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: shrinkWidth-50),
                      child: Text(
                        widget.title,
                        overflow: TextOverflow.ellipsis,
                        style: GlobalStyles.textStyles.textButtonSecondary,
                      ),
                    )
                  ),
                  AnimatedOpacity(
                    opacity: showText ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Visibility(
                      visible: showText,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.spacing16),
                        child: Text(widget.subtitle,
                          style: GlobalStyles.textStyles.textCaption3.copyWith(color: GlobalStyles.textSubtle)),
                      ),
                    )
                  ),
                ],
              )
            )
          ],
        ),
      )
    );
  }
}
