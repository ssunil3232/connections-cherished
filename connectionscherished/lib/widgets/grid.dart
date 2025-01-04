import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/widgets/grid-item.dart';
import 'package:flutter/material.dart';

class DetailsGrid extends StatelessWidget {
  const DetailsGrid({super.key, required this.data});
  final List<FriendModel> data;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            for (var item in data)
              ItemWidget(
                name: item.name ?? '',
                days: item.lastContactedDays,
                color: item.getSeverityColor(),
                data: item),
          ]
        ),
      )
    );
  }
}
