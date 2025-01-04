import 'package:connectionscherished/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

// ignore: must_be_immutable
class ListTileItem extends StatefulWidget {
  final String text;
  String ? subtitle;
  final Widget icon;
  bool? lastItem;
  bool ? showTrailingIcon;
  Widget ? trailingIcon;
  Function()? function; 
  ListTileItem({super.key, required this.icon, this.trailingIcon, required this.text, this.lastItem = false, this.function, this.subtitle, this.showTrailingIcon = true});
  @override
  _ListTileItemState createState() => _ListTileItemState();
}

class _ListTileItemState extends State<ListTileItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: (widget.lastItem == true) ? null : Border(
          bottom: BorderSide(
            color: GlobalStyles.cardBorderDefault,
            width: 1.0,
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () async {
          widget.function!();
        },
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          leading: widget.icon,
          subtitle: (widget.subtitle != null)
          ? Text(
              widget.subtitle!,
              style: GlobalStyles.textStyles.body1
            )
          : null,
          title: (widget.subtitle != null) 
          ? Text(
              widget.text,
              style: GlobalStyles.textStyles.body2.copyWith(
                color: GlobalStyles.globalTextSubtle
              ),
            ) 
          : Text(
            widget.text,
            style: GlobalStyles.textStyles.body1,
          ),
          trailing: widget.showTrailingIcon == false ? null : widget.trailingIcon ?? VariedIcon.varied(Symbols.arrow_forward_ios_rounded),
          splashColor: Colors.transparent,
        )
      )
    );
  }
}