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
        color: GlobalStyles.btnBgTertiary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: () async {
          widget.function!();
        },
        child: ListTile(
          dense: true,
          minVerticalPadding: 0,
          minTileHeight: 0,
          contentPadding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.spacing4, horizontal: GlobalStyles.spacingStates.spacing16),
          leading: widget.icon,
          subtitle: (widget.subtitle != null)
          ? Text(
              widget.subtitle!,
              style: GlobalStyles.textStyles.textBody
            )
          : null,
          title: (widget.subtitle != null) 
          ? Text(
              widget.text,
              style: GlobalStyles.textStyles.textCaption1.copyWith(
                color: GlobalStyles.textSubtle,
              ),
            ) 
          : Text(
            widget.text,
            style: GlobalStyles.textStyles.textBody,
          ),
          trailing: widget.showTrailingIcon == false ? null : widget.trailingIcon ?? VariedIcon.varied(Symbols.arrow_forward_ios_rounded),
          splashColor: Colors.transparent,
        )
      )
    );
  }
}