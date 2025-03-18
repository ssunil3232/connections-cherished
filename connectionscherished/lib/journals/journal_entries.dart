import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectionscherished/journals/journal_entry.dart';
import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/models/journal_model.dart';
import 'package:connectionscherished/services/friend_service.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/buttons/journal/journal_grid.dart';
import 'package:connectionscherished/widgets/navigation/top_nav_bar_widget.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class JournalEntries extends StatefulWidget {
  const JournalEntries({super.key, required this.friend});

  final FriendModel friend;
  @override
  JournalEntriesState createState() => JournalEntriesState();
}

class JournalEntriesState extends State<JournalEntries> {
  final _friendsService = GetIt.I.get<FriendService>();
  List<JournalModel> journalEntries = [];
  
  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadData() {
    getJournals();
    setState(() {
    });
  }

  Future<void> getJournals() async {
    try {
      journalEntries = await _friendsService.getFriendsJournals(widget.friend.friendId!);
      if (journalEntries.isNotEmpty) {
        journalEntries.sort((a, b) => b.entryTimestamp.compareTo(a.entryTimestamp));
      }
      setState(() {});
    } catch (e) {
      Exception('Error fetching journal entries: $e');
    }
  }

  Future<void> deleteJournalEntry(JournalModel item) async {
    try {
      await _friendsService.deleteJournalEntry(item);
      journalEntries.remove(item);
      setState(() {});
    } catch (e) {
      Exception('Error deleting journal entry: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBarWidget(
        showBorder: false,
        height: 100.0,
        header: Text(widget.friend.name ?? 'Journal entries', style: GlobalStyles.textStyles.titleHeader),
        showBackButton: true,
      ),
      body: PagePadding(
        bottomPadding: GlobalStyles.spacingStates.spacing32,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(journalEntries.isNotEmpty)
              Column(
                children: [
                  SizedBox(height: GlobalStyles.spacingStates.spacing32),
                  Row(
                    children: [
                      Text('You have', style: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.textSubtle),),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.spacing12),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                          decoration: BoxDecoration(
                            color: GlobalStyles.btnBgTertiary,
                            borderRadius: BorderRadius.circular(GlobalStyles.spacingStates.spacing16),
                          ),
                          child: Text(
                            '${journalEntries.length}',
                            style: GlobalStyles.textStyles.textH1,
                          ),
                        ),
                      ),
                      Text('journal entries', style: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.textSubtle),),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing32),
                    child: JournalGrid(
                      data: journalEntries,
                      onDelete: (item) => deleteJournalEntry(item),
                      onUpdate: loadData,
                    ),
                  ),
                ]
              ),
              if(journalEntries.isEmpty)
              Spacer(),
              if(journalEntries.isEmpty)
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: GlobalStyles.defaultTextBg,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: GlobalStyles.spacingStates.spacing44,
                    horizontal: GlobalStyles.spacingStates.spacing60
                  ),
                  child: Text(
                    "You have no journal entries\nwith this connection yet",
                    textAlign: TextAlign.center,
                    style: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.textSubtle)
                  )
                ),
              ),
              if(journalEntries.isEmpty)
              Spacer(),
            ]
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add action for the button here
            JournalModel newEntry = JournalModel(
              title: 'Journal entry',
              content: '',
              notes: '',
              mood: '',
              entryTimestamp: Timestamp.now(),
              friendId: widget.friend.friendId,
              journalId: '',
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JournalEntry(
                  journal: newEntry,
                  type: JournalEntryType.add,
                  onUpdate: () => loadData()
                ),
              )
            );
          },
          elevation: 0.5,
          backgroundColor: GlobalStyles.btnBgTertiary,
          shape: CircleBorder(),
          child: Icon(Icons.add, color: GlobalStyles.primaryText),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat
    );
  }
}