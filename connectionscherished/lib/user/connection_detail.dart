import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectionscherished/journals/journal_entries.dart';
import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/services/friend_service.dart';
import 'package:connectionscherished/services/user_service.dart';
import 'package:connectionscherished/services/util_service.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/dialog_widget.dart';
import 'package:connectionscherished/widgets/digital_clock.dart';
import 'package:connectionscherished/widgets/form-fields/date_picker/date_picker.dart';
import 'package:connectionscherished/widgets/form-fields/switch_widget.dart';
import 'package:connectionscherished/widgets/form-fields/timezone_picker_widget.dart';
import 'package:connectionscherished/widgets/profile/profile_img_name_dialog.dart';
import 'package:connectionscherished/widgets/profile/profile_img_name_update.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/form-fields/freq_picker/freq_field.dart';
import 'package:connectionscherished/widgets/navigation/top_nav_bar_widget.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

enum ConnectionType {add, edit, view}
// ignore: must_be_immutable
class ConnectionView extends StatefulWidget {
  FriendModel friend;
  ConnectionType type;
  ConnectionView({super.key, required this.friend, required this.type});
  @override
  ConnectionViewState createState() => ConnectionViewState();
}

class ConnectionViewState extends State<ConnectionView> {
  bool saving = false;
  final _userService = GetIt.I.get<UserService>();
  final _friendService = GetIt.I.get<FriendService>();
  final _utilService = GetIt.I.get<UtilService>();
  AvatarImgSelection userProfile = AvatarImgSelection(
    name: 'John Doe', 
    img: 'assets/images/avatars/avatar1.png', 
  );

  @override
  void initState() {
    super.initState();
    setUserConnection();
  }

  @override
  void dispose() {
    super.dispose();
  }

  setUserConnection() async {
    widget.friend.getSeverityColor();
    userProfile = AvatarImgSelection(
      name: widget.friend.name ?? 'John Doe', 
      img: widget.friend.profileImage, 
    );
  }

  Future<void> saveConnections() async {
    if (!mounted) return;
    setState(() {
      saving = true;
    });
    try {
      // await _utilService.uploadImage(userProfile.imgFile, widget.friend.friendId!);
      if(widget.type == ConnectionType.add) {
        await _userService.addFriendToUser(widget.friend, userProfile);
      } else {
        await _utilService.uploadImage(userProfile, widget.friend.friendId!);
        await _friendService.updateFriend(widget.friend.friendId!, widget.friend.toMap());
      }
    } catch(error){
      Exception("Failed to add connection");
    }
    
    if (!mounted) return;
    setState(() {
      saving = false;
    });
    Navigator.pop(context);
  }

  Future<void> getJournals() async {
    //retrieve journals & navigate to users journal with connection
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalEntries(friend: widget.friend)
      ),
    );
  }

  Future<void> deleteConnections() async {
    if (!mounted) return;
    setState(() {
      saving = true;
    });
    try {
      await _friendService.deleteFriend(widget.friend.friendId!);
    } catch(error){
      Exception("Failed to delete connection");
    }
    if (!mounted) return;
    setState(() {
      saving = false;
    });
    Navigator.pop(context);
  }

  getDaysAgo() {
    DateTime lastContact = DateTime.parse(widget.friend.lastContacted.toDate().toString());
    DateTime now = DateTime.now();
    widget.friend.lastContactedDays = now.difference(lastContact).inDays;
    // dataUpdate['color'] = calculateSeverity(dataUpdate['days']);
  }

  updateProfileData (AvatarImgSelection data) async {
    setState(() {
      widget.friend.name = data.name;
      widget.friend.profileImage = data.img;
      userProfile = data;
    });
    // await _imgProvider.updateAvatars(userProfile, friendUid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBarWidget(
        height: 100.0,
        header: Text(
          widget.type == ConnectionType.add ? "Add connection" : widget.type == ConnectionType.edit ? "Edit connection" : "Connection", 
          style: GlobalStyles.textStyles.titleHeader
        ),
        showBackButton: true,
        showBorder: false,
        actions: widget.type == ConnectionType.view ? [
          IconButton(
            onPressed: () {
              setState(() {
                widget.type = ConnectionType.edit;
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
        bottomPadding: GlobalStyles.spacingStates.spacing20,
        child: Center(
          child: saving
          ? const CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: GlobalStyles.spacingStates.spacing32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(bottom: GlobalStyles.spacingStates.spacing20),
                            child: Text(
                              'Your connection with,',
                              style: GlobalStyles.textStyles.textBody,
                            ),
                          )
                        ),
                      ],
                    ),
                    ProfileImgNameUpdate(
                      onUpdate: updateProfileData,
                      avatar: userProfile,
                      isEditEnabled : widget.type != ConnectionType.view,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.spacing16),
                      child: Text(
                        'You last cherished your connection',
                        style: GlobalStyles.textStyles.textBody
                      )
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                          decoration: BoxDecoration(
                            color: GlobalStyles.btnBgTertiary,
                            borderRadius: BorderRadius.circular(GlobalStyles.spacingStates.spacing16),
                          ),
                          child: Text(
                            '${widget.friend.lastContactedDays}',
                            style: GlobalStyles.textStyles.textH1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: GlobalStyles.spacingStates.spacing12),
                          child: Text('days ago', style: GlobalStyles.textStyles.textCaption1.copyWith(color: GlobalStyles.textSubtle)),
                        )
                      ],
                    ),
                    
                    //////////////////Section on details/////////////////////
                    Container(
                      padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing40),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: GlobalStyles.spacingStates.spacing12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Last contacted',
                                  style: GlobalStyles.textStyles.textBody
                                ),
                                SizedBox(width: GlobalStyles.spacingStates.spacing16),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.spacing32, vertical: GlobalStyles.spacingStates.spacing12),
                                  decoration: BoxDecoration(
                                    color: GlobalStyles.defaultTextBg,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    DateFormat('d MMM yyyy').format(DateTime.parse(widget.friend.lastContacted.toDate().toString())),
                                    style: GlobalStyles.textStyles.textH3,
                                  ),
                                ),
                                SizedBox(width: GlobalStyles.spacingStates.spacing4),
                                if(widget.type != ConnectionType.view)
                                IconButton(
                                  onPressed: () async {
                                    DateTime lastContactedDate = widget.friend.lastContacted.toDate();
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DatePicker(
                                          header: 'Last contacted',
                                          date: lastContactedDate.day,
                                          month: lastContactedDate.month,
                                          year: lastContactedDate.year,
                                          onChanged: (DateTime pickedDate) {
                                            setState(() {
                                              widget.friend.lastContacted = Timestamp.fromDate(pickedDate);
                                            });
                                            getDaysAgo();
                                          }
                                        );
                                      },
                                    );
                                  },
                                  icon: SvgPicture.asset(
                                    'assets/icons/calendar_icon.svg', 
                                    width: 24, 
                                    height: 24
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: GlobalStyles.spacingStates.spacing12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Alert every',
                                  style: GlobalStyles.textStyles.textBody
                                ),
                                SizedBox(width: GlobalStyles.spacingStates.spacing16),
                                Row(
                                  children: [
                                    FreqField(
                                      isDisabled: widget.type == ConnectionType.view,
                                      friend: widget.friend,
                                      fieldVal: widget.friend.alert.months.toString(),
                                      label: 'months',
                                      onChanged: (value){
                                        setState(() {
                                          widget.friend.alert = PeriodicAlert(
                                            weeks: value.weeks, 
                                            months: value.months, 
                                            days: value.days
                                          );
                                        });
                                      },
                                    ),
                                    FreqField(
                                      isDisabled: widget.type == ConnectionType.view,
                                      friend: widget.friend,
                                      fieldVal: widget.friend.alert.weeks.toString(),
                                      label: 'weeks',
                                      onChanged: (value){
                                        setState(() {
                                          widget.friend.alert = PeriodicAlert(
                                            weeks: value.weeks, 
                                            months: value.months, 
                                            days: value.days
                                          );
                                        });
                                      },
                                    ),
                                    FreqField(
                                      isDisabled: widget.type == ConnectionType.view,
                                      friend: widget.friend,
                                      fieldVal: widget.friend.alert.days.toString(),
                                      label: 'days',
                                      onChanged: (value){
                                        setState(() {
                                          widget.friend.alert = PeriodicAlert(
                                            weeks: value.weeks, 
                                            months: value.months, 
                                            days: value.days
                                          );
                                        });
                                      },
                                    ), 
                                  ],
                                ),
                              ]
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: GlobalStyles.spacingStates.spacing12),
                            child: Row(
                              crossAxisAlignment:CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Birthday',
                                  style: GlobalStyles.textStyles.textBody
                                ),
                                SizedBox(width: GlobalStyles.spacingStates.spacing16),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.spacing32, vertical: GlobalStyles.spacingStates.spacing12),
                                  decoration: BoxDecoration(
                                    color: GlobalStyles.defaultTextBg,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    DateFormat('d MMM').format(DateTime.parse(((widget.friend.dob ?? Timestamp.fromDate(DateTime(2024, 1, 1)))).toDate().toString())),
                                    style: GlobalStyles.textStyles.textH3,
                                  ),
                                ),
                                SizedBox(width: GlobalStyles.spacingStates.spacing4),
                                if(widget.type != ConnectionType.view)
                                IconButton(
                                  onPressed: () async {
                                    DateTime birthdate = (widget.friend.dob ?? Timestamp.fromDate(DateTime(2024, 1, 1))).toDate();
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DatePicker(
                                          header: 'Birthday',
                                          date: birthdate.day,
                                          month: birthdate.month,
                                          year: birthdate.year,
                                          setBirthday: true,
                                          onChanged: (DateTime pickedDate) {
                                            setState(() {
                                              widget.friend.dob = Timestamp.fromDate(pickedDate);
                                            });
                                            getDaysAgo();
                                          }
                                        );
                                      },
                                    );
                                  },
                                  icon: SvgPicture.asset(
                                    'assets/icons/calendar_icon.svg', 
                                    width: 24, 
                                    height: 24
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left:GlobalStyles.spacingStates.spacing4),
                                  child: SwitchWidget(
                                    isDisabled: widget.type == ConnectionType.view,
                                    initialState: widget.friend.alertOnBirthday,
                                    onChange: (value) {
                                      setState(() {
                                        widget.friend.alertOnBirthday = value;
                                      });
                                    },
                                    labelText: 'Alert',
                                  )
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: GlobalStyles.spacingStates.spacing12),
                            child: Row(
                              crossAxisAlignment:CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: GlobalStyles.spacingStates.spacing8),
                                  child: SvgPicture.asset('assets/icons/timezone_icon.svg', width: 24, height: 24),
                                ),
                                Text(
                                  'Timezone',
                                  style: GlobalStyles.textStyles.textBody
                                ),
                                SizedBox(width: GlobalStyles.spacingStates.spacing16),
                                Expanded(
                                  child: TimezonePickerWidget(
                                    isDisabled: widget.type == ConnectionType.view,
                                    initialTimezone: widget.friend.timezone,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.friend.timezone = value.location;
                                      });
                                    },
                                  )
                                )
                              ],
                            ),
                          ),
                          if(widget.type == ConnectionType.view)
                          Container(
                            margin: EdgeInsets.only(bottom: GlobalStyles.spacingStates.spacing12),
                            child: Row(
                              crossAxisAlignment:CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Time now',
                                  style: GlobalStyles.textStyles.textBody
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: GlobalStyles.spacingStates.spacing8),
                                  child: SvgPicture.asset('assets/icons/time_icon.svg', width: 24, height: 24),
                                ),
                                SizedBox(width: GlobalStyles.spacingStates.spacing16),
                                Center(
                                  child: DigitalClock(
                                    key: ValueKey(widget.friend.timezone),
                                    timezone: widget.friend.timezone
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                //////////////////Completed details/////////////////////
              if(widget.type == ConnectionType.view)
                CustomButtonWidget.secondary(
                  text: 'View journals',
                  onPressed: getJournals,
                  icon: Symbols.arrow_forward_ios_rounded,
                  iconAlignment: IconAlignment.end,
                ),
              if(widget.type != ConnectionType.view)
              Column(
                children: [
                  CustomButtonWidget.primary(
                    text: widget.type == ConnectionType.add ? 'Add connection' : 'Save connection',
                    onPressed: saveConnections,
                    showIsSaving: saving,
                  ),
                  if(widget.type == ConnectionType.edit)
                  Container(
                    padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing4),
                    child: CustomButtonWidget.tertiaryAlert(
                      text: 'Delete connection',
                      onPressed: (){
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
                                !value ? deleteConnections() : null;
                              },
                              // isWarning: true,
                            );
                          }
                        );
                      },
                    )
                  ),
                ],
              )
            ]
          )
        )
      )
    );
  }
}
