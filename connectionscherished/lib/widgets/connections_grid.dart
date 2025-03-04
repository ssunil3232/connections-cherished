import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/widgets/connection_grid_item.dart';
import 'package:flutter/material.dart';

class ConnectionsGrid extends StatefulWidget {
  const ConnectionsGrid({super.key, required this.data, required this.onDelete});
  final List<FriendModel> data;
  final Function (FriendModel) onDelete;

  @override
  _ConnectionsGridState createState() => _ConnectionsGridState();
}

class _ConnectionsGridState extends State<ConnectionsGrid> {
  late List<GlobalKey<ConnectionGridItemState>> _itemKeys = [];

  @override
  void initState() {
    super.initState();
    _initializeKeys();
  }

  @override
  void didUpdateWidget(covariant ConnectionsGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data.length != widget.data.length) {
      _initializeKeys();
    }
  }

  void _initializeKeys() {
    _itemKeys = List.generate(widget.data.length, (_) => GlobalKey<ConnectionGridItemState>());
  }

  void _handleCollapse({int? index}) {
    for (int i = 0; i < _itemKeys.length; i++) {
      if (i != index) {
        _itemKeys[i].currentState?.expand();
      }
    }
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
            return ConnectionGridItem(
              key: _itemKeys[i],
              image: item.profileImage,
              name: item.name ?? '',
              days: item.lastContactedDays,
              color: item.getSeverityColor(),
              data: item,
              onCollapse: () => _handleCollapse(index: i),
              onDelete: (item)=> widget.onDelete(item),
            );
          }),
        ),
      )
    );
  }
}
