import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectionscherished/main.dart';
import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/routes.dart';
import 'package:connectionscherished/services/user_service.dart';
import 'package:connectionscherished/styles/button_styles.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/user/add_connection.dart';
import 'package:connectionscherished/widgets/classification.dart';
import 'package:connectionscherished/widgets/grid.dart';
import 'package:connectionscherished/widgets/navigation/top_nav_bar_widget.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver, RouteAware {
  List<FriendModel> connections = [];
  Future<List<FriendModel>>? connectionsFuture;
  final _userService = GetIt.I.get<UserService>();
  final _authService = FirebaseAuth.instance;
  UniqueKey futureBuilderKey = UniqueKey();

  void loadData() {
    getConnections();
    setState(() {
      futureBuilderKey = UniqueKey(); // Update the key to force rebuild
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute<dynamic>);
  }

  @override
  void didPopNext() {
    // Called when the current route has been popped off and the user returns to this route.
    loadData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      loadData();
    }
  }

  Future<void> getConnections() async {
    try {
      connections = await _userService.getFriends();
      if (connections.isNotEmpty) {
        connections.sort((a, b) => b.calculatePriorityScore().compareTo(a.calculatePriorityScore()));
      }
      setState(() {}); // Ensure the UI is updated
    } catch (e) {
      debugPrint('Error fetching connections: $e');
    }
  }

  addConnection() {
      FriendModel friend = FriendModel(
        name: 'John Doe',
        lastContacted: Timestamp.now(),
        dob: Timestamp.now(),
        alertOnBirthday: true,
        alert: PeriodicAlert(days: 1, months: 0, years: 0),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddConnectionView(
            friend: friend,
            type: ConnectionType.add
          )
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        key: futureBuilderKey,
        future: connectionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: const LinearProgressIndicator(
                backgroundColor: Colors.black,
              ),
            );
          } else {
            if (snapshot.hasError) {
              return Container(
                color: Colors.white,
                child: const Center(
                  child: Text('Something went wrong, try again.'),
                ),
              );
            } else {
              return Scaffold(
                appBar: TopNavBarWidget(
                  bgColor: Theme.of(context).colorScheme.inversePrimary,
                  showBorder: false,
                  header: RichText(
                    text: TextSpan(
                      style: GoogleFonts.juliusSansOne(),
                      children: const [
                        TextSpan(
                          text: 'Connections ',
                          style: TextStyle(fontSize: 20, color: Color(0xff8719BB)),
                        ),
                        TextSpan(
                            text: 'Cherished',
                            style: TextStyle(fontSize: 20, color: Colors.black87)),
                      ],
                    ),
                  ),
                  showBackButton: false,
                  actions: [
                    PopupMenuButton<String>(
                      icon: VariedIcon.varied(
                        Symbols.user_attributes_rounded,
                        size: 40,
                        weight: 300
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(
                          color: GlobalStyles.globalTextSubtle,
                        ),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.all(0),
                      offset: const Offset(50, 50),
                      color: GlobalStyles.globalBgDefault,
                      style: const ButtonStyle(
                        padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                        splashFactory: NoSplash.splashFactory,
                        overlayColor: WidgetStatePropertyAll(Colors.transparent),
                      ),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'settings',
                          padding: const EdgeInsets.all(0),
                          height: 32.0,
                          child:Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(0),
                            constraints: const BoxConstraints(
                              minWidth: 0,
                              maxWidth: double.infinity,
                            ),
                            child: Text(
                              'Settings',
                              style: GlobalStyles.textStyles.body1,
                            ),
                          ),
                          onTap: (){
                            Navigator.pushNamed(context, Routes.userProfile);
                          },
                        ),
                        PopupMenuItem<String>(
                          value: 'logout',
                          padding: const EdgeInsets.all(0),
                          height: 32.0,
                          child:Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(0),
                            constraints: const BoxConstraints(
                              minWidth: 0,
                              maxWidth: double.infinity,
                            ),
                            child: Text(
                              'Logout',
                              style: GlobalStyles.textStyles.body1,
                            ),
                          ),
                          onTap: () async {
                            await _authService.signOut();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              Routes.authOptions,
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
                body: PagePadding(
                  bottomPadding: 20.0,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: GlobalStyles.spacingStates.spacing24,),
                        Image.asset(
                          'assets/images/logo.png',
                          width: 95,
                        ),
                        Container(
                          // margin: const EdgeInsets.all(20),
                          alignment: Alignment.center,
                          child: RichText(
                            textAlign:TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Where you can ',
                                    style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.juliusSansOne().fontFamily,
                                    )),
                                TextSpan(
                                    text: 'cherish', // The word you want to color
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontFamily: GoogleFonts.juliusSansOne()
                                            .fontFamily,
                                        color: Colors
                                            .deepPurple) // Change the color as needed
                                    ),
                                TextSpan(
                                    text: ' your connections better...',
                                    style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.juliusSansOne().fontFamily,
                                    )), // Text after the colored word
                              ],
                            ),
                          ),
                        ),
                        (connections.isEmpty)?
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Text(
                                  'Starting adding connections to cherish!',
                                  style: GlobalStyles.textStyles.body2.copyWith(
                                    // fontSize: 15,
                                    color: GlobalStyles.globalTextSubtle,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              FilledButton(
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all(
                                    const EdgeInsets.symmetric(horizontal: 10)
                                  ),
                                  textStyle: WidgetStateProperty.all(
                                    GlobalStyles.textStyles.body2
                                  ),
                                  backgroundColor: WidgetStateProperty.all(
                                    ButtonStyles.secondaryBtnStyle.bgDefault
                                  ),
                                  foregroundColor: WidgetStateProperty.all(
                                    GlobalStyles.brandColor2
                                  )
                                ),
                                onPressed: addConnection, 
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Add Connection', style: GlobalStyles.textStyles.body2,), 
                                    const SizedBox(width: 4),
                                    VariedIcon.varied(Symbols.add_rounded, size: 20, weight: 300),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/splash1.png',
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Text(
                                          textAlign: TextAlign.center,
                                          '"The connections we share are the footprints we leave behind in the hearts of others."',
                                          style:GlobalStyles.textStyles.body2.copyWith(
                                            fontSize: 20,
                                            color: const Color.fromARGB(255, 33, 8, 45),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 20),
                                          child: Text(
                                            textAlign: TextAlign.end,
                                            '- Tim Fargo',
                                            style:GlobalStyles.textStyles.body2.copyWith(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 15,
                                              color: const Color.fromARGB(255, 88, 56, 103),
                                            ),
                                          )
                                        )
                                      ]
                                    )
                                  )
                                ],
                              )
                            ]
                          )
                          :
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top: 20),
                                alignment: Alignment.center,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'You need to cherish your connection with',
                                  style: GlobalStyles.textStyles.body2.copyWith(
                                    // fontSize: 15,
                                    color: GlobalStyles.globalTextSubtle,
                                  ),
                                ),
                              ),
                              getTopConnection()
                            ],
                          ),
                        if(connections.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Classification(),
                                
                              ),
                              FilledButton(
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 10)),
                                  textStyle: WidgetStateProperty.all(GlobalStyles.textStyles.body2),
                                  backgroundColor: WidgetStateProperty.all(ButtonStyles.secondaryBtnStyle.bgDefault),
                                  foregroundColor: WidgetStateProperty.all(GlobalStyles.brandColor2)
                                ),
                                onPressed: addConnection, 
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Add Connection', style: GlobalStyles.textStyles.body2, textAlign: TextAlign.center,), 
                                    const SizedBox(width: 4),
                                    VariedIcon.varied(Symbols.add_rounded, size: 20, weight: 300),
                                  ],
                                ),
                              )
                            ]
                          )
                        ),
                        if(connections.isNotEmpty)
                        SizedBox(
                          height: 30,
                          child: Row(children: [
                            const SizedBox(
                              width: 100,
                              child: Text('Name'),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 80),
                              child: const SizedBox(
                                child: Text('Last Contacted'),
                              ),
                            ),
                          ]),
                        ),
                        Expanded(
                          child: DetailsGrid(data: connections)
                        ),
                      ],
                    ),
                  )
                ),
              );
            }
          }
        });
  }

  Widget getTopConnection(){
    return Stack(
      alignment: Alignment.center,
      children: [
      Image.asset(
        'assets/images/splash8.png',
      ),
      Text(
        connections.first.name?? '',
        style: const TextStyle(
          fontSize: 30,
          color: Color(0xffB350E1),
        ),
      )
    ],);
  }
}
