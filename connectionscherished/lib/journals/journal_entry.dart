import 'package:connectionscherished/models/journal_model.dart';
import 'package:connectionscherished/services/friend_service.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/form-fields/dropdown_widget.dart';
import 'package:connectionscherished/widgets/form-fields/input_field_widget.dart';
import 'package:connectionscherished/widgets/navigation/top_nav_bar_widget.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

enum JournalEntryType {add, edit, view}
// ignore: must_be_immutable
class JournalEntry extends StatefulWidget {
  JournalModel journal;
  JournalEntryType type;
  final VoidCallback onUpdate;

  JournalEntry({super.key, required this.journal, required this.type, required this.onUpdate});
  @override
  JournalEntryState createState() => JournalEntryState();
}

class JournalEntryState extends State<JournalEntry> {
  bool saving = false;
  final _friendService = GetIt.I.get<FriendService>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _notesController = TextEditingController();
  bool _allValid = false;
  bool _showTitleError = false;
  List<String> moodOptions = ['Happy', 'Excited', 'Sad', 'Angry'];
  List<String> moodEmojis = ['happy_emoji.svg', 'excited_emoji.svg', 'sad_emoji.svg', 'angry_emoji.svg'];
  String ? _selectedMood;
  bool isEditEnabled = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isEditEnabled = widget.type != JournalEntryType.view;
    });
    _titleController.addListener(_updateButtonState);
    _contentController.addListener(_updateButtonState);
    _notesController.addListener(_updateButtonState);
    setInitialValues();
  }

  setInitialValues() {
    _titleController.text = widget.journal.title;
    _contentController.text = widget.journal.content ?? '';
    _notesController.text = widget.journal.notes ?? '';
    _selectedMood = widget.journal.mood;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool _isTitleValid() {
    final title = _titleController.text.trim();
    if(title.isEmpty) {
      _showTitleError = false;
      return false;
    }
    return !_showTitleError;
  }

  void _updateButtonState() {
    setState(() {
      _allValid = _isTitleValid();
    });
  }

  Future<void> saveEntry() async {
    widget.journal.title = _titleController.text;
    widget.journal.content = _contentController.text;
    widget.journal.notes = _notesController.text;
    widget.journal.mood = _selectedMood;

    setState(() {
      saving = true;
      FocusScope.of(context).unfocus();
    });
    try {
      if(widget.type == JournalEntryType.add) {
        await _friendService.addJournalEntry(widget.journal);
      } else {
        await _friendService.updateJournalEntry(widget.journal);
      }
      widget.onUpdate();
    } catch(error){
      Exception("Failed to add/edit journal entry");
    }
    setState(() {
      saving = false;
    });
    Navigator.pop(context);
  }

  Future<void> deleteJournalEntry() async {
    setState(() {
      saving = true;
      FocusScope.of(context).unfocus();
    });
    try {
      await _friendService.deleteJournalEntry(widget.journal);
    } catch(error){
      Exception("Failed to delete journal entry");
    }
    setState(() {
      saving = false;
    });
    Navigator.pop(context);
  }

  Future<void> navigationAction() async{
    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBarWidget(
        height: 100.0,
        header: Text(
          widget.type == JournalEntryType.add ? "New entry" : widget.type == JournalEntryType.edit || isEditEnabled ? "Edit entry" : widget.journal.title, 
          style: GlobalStyles.textStyles.titleHeader
        ),
        showBackButton: true,
        showBorder: false,
        backAction: navigationAction,
        actions: widget.type == JournalEntryType.view && !isEditEnabled ? [
          IconButton(
            onPressed: () {
              setState(() {
                widget.type = JournalEntryType.edit;
                isEditEnabled = true;
              });
            },
            icon: SvgPicture.asset(
              'assets/icons/edit_icon.svg', 
              width: 24, 
              height: 24
            ),
          )
        ] : null,
      ),
      body: PagePadding(
        bottomPadding: GlobalStyles.spacingStates.spacing32,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing32),
                      child: InputFieldWidget(
                        controller: _titleController,
                        keyboardType: TextInputType.text,
                        labelText: 'Title',
                        placeholderText: 'Journal entry title',
                        errorState: _showTitleError,
                        errorText: "❌ Title cannot be empty",
                        errorMaxLines: 4,
                        readOnly: saving || (widget.type == JournalEntryType.view && !isEditEnabled),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing16),
                      child: InputFieldWidget(
                        controller: _contentController,
                        keyboardType: TextInputType.multiline,
                        labelText: 'How was your conversation?',
                        placeholderText: 'Enter your thoughts here',
                        multilineHeight: 240,
                        readOnly: saving || (widget.type == JournalEntryType.view && !isEditEnabled),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing16),
                      child: InputFieldWidget(
                        controller: _notesController,
                        keyboardType: TextInputType.multiline,
                        labelText: 'Anything you wish to remember?',
                        placeholderText: 'Keep your special reminders or notes here',
                        readOnly: saving || (widget.type == JournalEntryType.view && !isEditEnabled),
                        multilineHeight: 150,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing28),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: GlobalStyles.spacingStates.spacing16),
                            child: Text('Mood:', style: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.textSubtle)),
                          ),
                          Expanded(
                            child: Row(
                              children : [
                                CustomDropdownWidget(
                                  disabled: saving || (widget.type == JournalEntryType.view && !isEditEnabled),
                                  offset: Offset(0, (200+55+8)),
                                  placeholderText: 'Select a mood',
                                  onChanged:(value) {
                                    setState(() {
                                      _selectedMood = value;
                                    });
                                    _updateButtonState();
                                  }, 
                                  dropdownItems: moodOptions
                                    .asMap().entries.map((entry){
                                      int index = entry.key;
                                      String value = entry.value;
                                      return DropdownItems(
                                        value: value,
                                        label: value,
                                        customItem: Row(
                                          children: [
                                            Text(value),
                                            Padding(
                                              padding: EdgeInsets.only(left: 8),
                                              child: SvgPicture.asset('assets/icons/${moodEmojis[index]}', width: 24, height: 24),
                                            )
                                          ],
                                        ),
                                        enabledButton: true
                                      );
                                    }).toList(),
                                  initialValue: _selectedMood,
                                  menuWidth: MediaQuery.of(context).size.width * 0.5,
                                  menuHeight: 200,
                                  buttonWidth: MediaQuery.of(context).size.width * 0.5,
                                ),
                                if(_selectedMood != null && moodOptions.contains(_selectedMood!)) 
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: SvgPicture.asset('assets/icons/${moodEmojis[moodOptions.indexOf(_selectedMood!)]}', width: 24, height: 24),
                                )
                              ]
                            )
                          )
                        ],
                      )
                    ),
                  ]
                ),
              ),
                //////////////////Completed details/////////////////////
              if(widget.type != JournalEntryType.view|| isEditEnabled)
                CustomButtonWidget.secondary(
                  text: 'Save',
                  onPressed: !_allValid || saving ? null : saveEntry,
                  showIsSaving: saving,
                ),
            ]
          )
        )
      )
    );
  }
}