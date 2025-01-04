import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/user/add_connection.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget(
      {super.key,
      required this.name,
      required this.days,
      required this.color,
      required this.data});

  final String name;
  final int days;
  final Color color;
  final FriendModel data;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: color,
      child: SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 100,
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: GlobalStyles.textStyles.caption1,
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 100,
                child: Text('$days days ago', style: GlobalStyles.textStyles.caption1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: IconButton(
                splashColor: Colors.transparent,
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                        AddConnectionView(friend: data, type: ConnectionType.update)),
                  );
                },
                icon: VariedIcon.varied(Symbols.edit,color: GlobalStyles.brandColor1),
              ),
            )
          ],
        )
      ),
    );
  }
}
