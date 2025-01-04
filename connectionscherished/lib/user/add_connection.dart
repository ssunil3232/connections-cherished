import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/services/friend_service.dart';
import 'package:connectionscherished/services/user_service.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/profile.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/freq_picker/freq_field.dart';
import 'package:connectionscherished/widgets/navigation/top_nav_bar_widget.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

enum ConnectionType {add, update}
// ignore: must_be_immutable
class AddConnectionView extends StatefulWidget {
  FriendModel friend;
  ConnectionType type;
  AddConnectionView({super.key, required this.friend, required this.type});
  @override
  AddConnectionViewState createState() => AddConnectionViewState();
}

class AddConnectionViewState extends State<AddConnectionView> {
  bool saving = false;
  final _userService = GetIt.I.get<UserService>();
  final _friendService = GetIt.I.get<FriendService>();

  @override
  void initState() {
    super.initState();
    setUserConnection();
  }

  setUserConnection() async {
    widget.friend.getSeverityColor();
  }

  Future<void> saveConnections() async {
    setState(() {
      saving = true;
    });
    try {
      if(widget.type == ConnectionType.add) {
        await _userService.addFriendToUser(widget.friend);
      } else {
        await _friendService.updateFriend(widget.friend.friendId!, widget.friend.toMap());
      }
    } catch(error){
      Exception("Failed to add connection");
    }
    
    setState(() {
      saving = false;
    });
    Navigator.pop(context);
  }

  Future<void> deleteConnections() async {
    setState(() {
      saving = true;
    });
    try {
      await _friendService.deleteFriend(widget.friend.friendId!);
    } catch(error){
      Exception("Failed to add connection");
    }
    
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

  updateProfileData (data){
    setState(() {
      widget.friend.name = data['name'];
      widget.friend.profileImage = data['img'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBarWidget(
        bgColor: Theme.of(context).colorScheme.inversePrimary,
        header: RichText(
          text: TextSpan(
            style: GoogleFonts.juliusSansOne(),
            children: [
              TextSpan(
                text: widget.type == ConnectionType.add ? 'Add ' : 'Update ',
                style: const TextStyle(fontSize: 20, color: Color(0xff8719BB)),
              ),
              const TextSpan(
                text: 'Connection',
                style: TextStyle(fontSize: 20, color: Colors.black87)
              ),
            ],
          ),
        ),
        showBackButton: true,
        showBorder: false,
      ),
      body: PagePadding(
        child: Center(
          child: saving
          ? const CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            padding:const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Your connection with,',
                              style: GlobalStyles.textStyles.body1.copyWith(color: GlobalStyles.globalTextSubtle),
                            ),
                          )
                        ),
                      ],
                    ),
                    Profile(
                      onUpdate: updateProfileData,
                      name: widget.friend.name ?? 'John Doe',
                      img: widget.friend.profileImage.isEmpty ? 'assets/images/profile.png' : widget.friend.profileImage,
                    ),
                    Container(
                      padding:const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'You last cherished your connection',
                        style: GlobalStyles.textStyles.body2.copyWith(color: GlobalStyles.globalTextSubtle),
                      )
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                      decoration: BoxDecoration(
                        color: widget.friend.getSeverityColor(),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        '${widget.friend.lastContactedDays} days ago',
                        style: TextStyle(
                          fontSize: 30,
                          color: widget.friend.calculateSeverity() == 1 
                            ? Colors.white 
                            : widget.friend.calculateSeverity()  == 2
                            ? Colors.grey[700]
                            : Colors.grey[800],
                          fontFamily: GoogleFonts.interTight(fontWeight: FontWeight.w200).fontFamily
                        )
                      ),
                    ),
                    //////////////////Section on details/////////////////////
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Last contacted: ',style: GlobalStyles.textStyles.caption1.copyWith(color: GlobalStyles.globalTextSubtle),),
                                const SizedBox(width: 4,),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 4,),
                                  decoration: BoxDecoration(
                                    color: GlobalStyles.globalBgSubtle,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    DateFormat('d MMM yyyy').format(DateTime.parse(widget.friend.lastContacted.toDate().toString())),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily:GoogleFonts.interTight(fontWeight:FontWeight.w300).fontFamily
                                    )
                                  ),
                                ),
                                const SizedBox(width: 8,),
                                IconButton(
                                  onPressed: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context:context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now()
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        widget.friend.lastContacted = Timestamp.fromDate(pickedDate);
                                      });
                                      getDaysAgo();
                                    }
                                  },
                                  icon: Icon(Icons.calendar_month,color: GlobalStyles.primaryPalette.primaryBorder),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Alert every: ',style: GlobalStyles.textStyles.caption1.copyWith(color: GlobalStyles.globalTextSubtle),),
                                const SizedBox(width: 4,),
                                Row(
                                  children: [
                                    FreqField(
                                      friend: widget.friend,
                                      fieldVal: widget.friend.alert.years.toString(),
                                      label: 'years',
                                      onChanged: (value){
                                        setState(() {
                                          widget.friend.alert = PeriodicAlert(
                                            years: value.years, 
                                            months: value.months, 
                                            days: value.days
                                          );
                                        });
                                      },
                                    ),
                                    FreqField(
                                      friend: widget.friend,
                                      fieldVal: widget.friend.alert.months.toString(),
                                      label: 'months',
                                      onChanged: (value){
                                        setState(() {
                                          widget.friend.alert = PeriodicAlert(
                                            years: value.years, 
                                            months: value.months, 
                                            days: value.days
                                          );
                                        });
                                      },
                                    ),
                                    FreqField(
                                      friend: widget.friend,
                                      fieldVal: widget.friend.alert.days.toString(),
                                      label: 'days',
                                      onChanged: (value){
                                        setState(() {
                                          widget.friend.alert = PeriodicAlert(
                                            years: value.years, 
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
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              crossAxisAlignment:CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Birthday: ',style: GlobalStyles.textStyles.caption1.copyWith(color: GlobalStyles.globalTextSubtle)),
                                const SizedBox(width: 4,),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 4,),
                                  decoration: BoxDecoration(
                                    color: GlobalStyles.globalBgSubtle,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    DateFormat('d MMM yyyy').format(DateTime.parse((widget.friend.dob ?? Timestamp.now()).toDate().toString())),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily:GoogleFonts.interTight(fontWeight:FontWeight.w300).fontFamily
                                    )
                                  ),
                                ),
                                const SizedBox(width: 8,),
                                IconButton(
                                  onPressed: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context:context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now()
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        widget.friend.dob =Timestamp.fromDate(pickedDate);
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.calendar_month,color: GlobalStyles.primaryPalette.primaryBorder),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left:4.0, top: 20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Switch(
                                        value: widget.friend.alertOnBirthday,
                                        activeColor:const Color(0xff8719BB),
                                        onChanged: (bool value) {
                                          setState(() {
                                            widget.friend.alertOnBirthday = value;
                                          });
                                        },
                                      ),
                                      Text('Alert',
                                        style: GlobalStyles.textStyles.caption2.copyWith(color: GlobalStyles.globalTextSubtle)
                                      ),
                                    ],
                                  )
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                //////////////////Completed details/////////////////////
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: CustomButtonWidget.primary(
                      text: widget.type == ConnectionType.add ? 'Add connection' : 'Save connection',
                      onPressed: saveConnections,
                      showIsSaving: saving,
                    )
                  ),
                  if(widget.type == ConnectionType.update)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: CustomButtonWidget.primaryAlert(
                      text: 'Delete connection',
                      onPressed: deleteConnections,
                    )
                  ),
                  const SizedBox(height: 12.0,)
                ],
              )
            ]
          )
        )
      )
    );
  }
}
