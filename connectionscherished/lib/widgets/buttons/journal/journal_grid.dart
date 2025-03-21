import 'package:connectionscherished/models/journal_model.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/buttons/journal/journal_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalGrid extends StatefulWidget {
  const JournalGrid({super.key, required this.data, required this.onDelete, required this.onUpdate});
  final List<JournalModel> data;
  final Function (JournalModel) onDelete;
  final VoidCallback onUpdate;

  @override
  _JournalGridState createState() => _JournalGridState();
}

class _JournalGridState extends State<JournalGrid> {
  late List<GlobalKey<JournalGridItemState>> _itemKeys = [];

  @override
  void initState() {
    super.initState();
    _initializeKeys();
  }

  @override
  void didUpdateWidget(covariant JournalGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data.length != widget.data.length) {
      _initializeKeys();
    }
  }

  void _initializeKeys() {
    _itemKeys = List.generate(widget.data.length, (_) => GlobalKey<JournalGridItemState>());
  }

  void _handleCollapse({int? index}) {
    for (int i = 0; i < _itemKeys.length; i++) {
      if (i != index) {
        _itemKeys[i].currentState?.expand();
      }
    }
  }

  void _handleUpdates(){
    _initializeKeys();
    for (int i = 0; i < _itemKeys.length; i++) {
      _itemKeys[i].currentState?.expand();
    }
    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 100),
        child: Column(
          spacing: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing8),
          children: List.generate(widget.data.length, (i) {
            final item = widget.data[i];
            return JournalGridItem(
              key: _itemKeys[i],
              title: item.title,
              subtitle: DateFormat('d MMM yyyy HH:mm').format(item.entryTimestamp.toDate()).toString(),
              color: GlobalStyles.topNavBg,
              data: item,
              onCollapse: () => _handleCollapse(index: i),
              onDelete: (item)=> widget.onDelete(item),
              onUpdate: _handleUpdates,
            );
          }),
        ),
      )
    );
  }
}
