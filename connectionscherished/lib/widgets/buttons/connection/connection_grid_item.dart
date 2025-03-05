import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/user/connection_detail.dart';
import 'package:connectionscherished/widgets/cached_image_widget.dart';
import 'package:connectionscherished/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ConnectionGridItem extends StatefulWidget {
  const ConnectionGridItem({
    super.key,
    required this.name,
    required this.image,
    required this.days,
    required this.color,
    required this.data,
    required this.onCollapse,
    required this.onDelete,
  });

  final String name;
  final String image;
  final int days;
  final Color color;
  final FriendModel data;
  final VoidCallback onCollapse;
  final Function (FriendModel) onDelete;

  @override
  State<ConnectionGridItem> createState() => ConnectionGridItemState();
}

class ConnectionGridItemState extends State<ConnectionGridItem> {
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

  Future<void> deleteConnection () async {
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
                    ConnectionView(friend: widget.data, type: ConnectionType.edit)
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
                      "assets/images/sad-face.png",
                      width: 150,
                      height: 150,
                    ),
                    descriptions: const ["Are you sure you want to\ndelete this connection?"],
                    confirmTitle: "No, let’s keep it",
                    cancelTitle: "Yes, let’s delete",
                    onResponse: (value){
                      !value ? deleteConnection() : null;
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
                    ConnectionView(friend: widget.data, type: ConnectionType.view)
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
            CachedImageWidget(
              height: 44, 
              width: 44, 
              imageUrlProvided: widget.image
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.spacing16),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: shrinkWidth-10),
                      child: Text(
                        widget.name,
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
                        child: Text('${widget.days} days ago',
                          style: GlobalStyles.textStyles.textButtonSecondary),
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
