import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectionscherished/main.dart';
import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/models/user_model.dart';
import 'package:connectionscherished/services/auth_service.dart';
import 'package:connectionscherished/services/friend_service.dart';
import 'package:connectionscherished/services/user_service.dart';
import 'package:connectionscherished/styles/button_styles.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/user/connection_detail.dart';
import 'package:connectionscherished/widgets/cached_image_widget.dart';
import 'package:connectionscherished/widgets/classification.dart';
import 'package:connectionscherished/widgets/connections_grid.dart';
import 'package:connectionscherished/widgets/navigation/top_nav_bar_widget.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
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
  final _accountService = GetIt.I.get<AuthService>();
  final _friendService = GetIt.I.get<FriendService>();
  UniqueKey futureBuilderKey = UniqueKey();
  UserModel ? user;

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
    loadUser();
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

  loadUser() async {
    user = await _accountService.getLoggedInUser();
  }

  Future<void> getConnections() async {
    try {
      connections = await _userService.getFriends();
      if (connections.isNotEmpty) {
        connections.sort((a, b) => b.calculatePriorityScore().compareTo(a.calculatePriorityScore()));
      }
      setState(() {}); // Ensure the UI is updated
    } catch (e) {
      Exception('Error fetching connections: $e');
    }
  }

  Future<void> deleteConnection (FriendModel item) async {
    // setState(() {
    //   saving = true;
    // });
    try {
      await _friendService.deleteFriend(item.friendId!);
      await getConnections();
    } catch(error){
      Exception("Failed to delete connection");
    }
    // setState(() {
    //   saving = false;
    // });
  }

  addConnection() {
    FriendModel newFriend = FriendModel(
      name: 'John Doe',
      lastContacted: Timestamp.now(),
      dob: null,
      alertOnBirthday: true,
      alert: PeriodicAlert(days: 0, months: 0, weeks: 1),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConnectionView(
          friend: newFriend,
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
              color: GlobalStyles.defaultBg,
              child: LinearProgressIndicator()
            );
          } else {
            if (snapshot.hasError) {
              return Container(
                color: GlobalStyles.defaultBg,
                child: Center(
                  child: Text(
                    'Something went wrong, try again.',
                    style: GlobalStyles.textStyles.textH3.copyWith(color: GlobalStyles.btnBorderError),
                  ),
                ),
              );
            } else {
              return Scaffold(
                appBar: TopNavBarWidget(
                  showBorder: false,
                  height: 100.0,
                  header: Text("Connections Cherished", style: GlobalStyles.textStyles.titleHeader),
                  showBackButton: false,
                ),
                body: PagePadding(
                  bottomPadding: GlobalStyles.spacingStates.spacing20,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: GlobalStyles.spacingStates.spacing24,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CachedImageWidget(
                              height: 90,
                              width: 90,
                              imageUrlProvided: 'assets/images/avatar1.png',
                            ),
                            SizedBox(width: GlobalStyles.spacingStates.spacing16),
                            SvgPicture.asset('assets/icons/wave_icon.svg', width: 36, height: 36),
                            SizedBox(width: GlobalStyles.spacingStates.spacing8),
                            Text(
                              'Hello ${user?.userName ?? ''}!',
                              style: GlobalStyles.textStyles.textH2Bold
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing8)),
                        (connections.isEmpty)?
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/logo.png',
                                width: 146,
                                height: 140,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: RichText(
                                  textAlign:TextAlign.center,
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Where you can ',
                                        style: GlobalStyles.textStyles.textH3
                                      ),
                                      TextSpan(
                                        text: 'cherish\n',
                                        style: GlobalStyles.textStyles.textH3Varaint
                                      ),
                                      TextSpan(
                                        text: 'your ',
                                        style: GlobalStyles.textStyles.textH3
                                      ),
                                      TextSpan(
                                        text: 'connections',
                                        style: GlobalStyles.textStyles.textH3Varaint
                                      ),
                                      TextSpan(
                                        text: ' better',
                                        style: GlobalStyles.textStyles.textH3
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing32, bottom: GlobalStyles.spacingStates.spacing8),
                                alignment: Alignment.center,
                                child: Text(
                                  'Start by adding a connection',
                                  style: GlobalStyles.textStyles.textCaption1.copyWith(
                                    color: GlobalStyles.textSubtle,
                                  ),
                                ),
                              ),
                              FilledButton(
                                style: ButtonStyles.tertiaryButton,
                                onPressed: addConnection, 
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Add Connection', style: GlobalStyles.textStyles.textButtonSecondary), 
                                    SizedBox(width: 4),
                                    VariedIcon.varied(Symbols.add_rounded, size: 24, weight: 300, color: GlobalStyles.primaryText),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: GlobalStyles.spacingStates.spacing24,
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/quote-bg-image.png',
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Text(
                                          textAlign: TextAlign.center,
                                          '"The connections we share are the footprints we leave behind in the hearts of others."',
                                          style:GlobalStyles.textStyles.textCaption1
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing8),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            '- Tim Fargo',
                                            style: GlobalStyles.textStyles.textCaption1
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
                                padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing24),
                                alignment: Alignment.center,
                                child: RichText(
                                  textAlign:TextAlign.center,
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Cherish',
                                        style: GlobalStyles.textStyles.textH3Varaint
                                      ),
                                      TextSpan(
                                        text: ' your ',
                                        style: GlobalStyles.textStyles.textH3
                                      ),
                                      TextSpan(
                                        text: 'connection',
                                        style: GlobalStyles.textStyles.textH3Varaint
                                      ),
                                      TextSpan(
                                        text: ' with',
                                        style: GlobalStyles.textStyles.textH3
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              getTopConnection()
                            ],
                          ),
                        if(connections.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.spacing24),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Classification(),
                              ),
                              FilledButton(
                                style: ButtonStyles.tertiaryButton.copyWith(
                                  padding: WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(
                                      vertical: GlobalStyles.spacingStates.spacing8, 
                                      horizontal: GlobalStyles.spacingStates.spacing8
                                    )
                                  ),
                                ),
                                onPressed: addConnection, 
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 4,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    VariedIcon.varied(Symbols.add_rounded, size: 24, weight: 500, color: GlobalStyles.primaryText),
                                    Text('Add\nconnection', style: GlobalStyles.textStyles.textButtonTertiary, textAlign: TextAlign.center), 
                                  ],
                                ),
                              )
                            ]
                          )
                        ),
                        if(connections.isNotEmpty)
                        Container(
                          padding: EdgeInsets.only(
                            bottom: GlobalStyles.spacingStates.spacing4, 
                            right: GlobalStyles.spacingStates.spacing16,
                            left: GlobalStyles.spacingStates.spacing8
                          ),
                          child: Row(
                            children: [
                              Text('Connection', style: GlobalStyles.textStyles.textCaption1,),
                              Spacer(),
                              Text('Last contacted', style: GlobalStyles.textStyles.textCaption1,),
                            ]
                          ),
                        ),
                        Expanded(
                          child: ConnectionsGrid(
                            data: connections,
                            onDelete: (item) => deleteConnection(item),
                          )
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.spacing16),
      child: FilledButton(
        style: ButtonStyles.tertiaryButton.copyWith(
          backgroundColor: WidgetStateProperty.all(GlobalStyles.defaultTextBg),
          foregroundColor: WidgetStateProperty.all(GlobalStyles.primaryText),
        ),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConnectionView(
                friend: connections.first,
                type: ConnectionType.edit
              )
            )
          );
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 200),
          child: Text(
            connections.first.name?? '',
            style: GlobalStyles.textStyles.textH1,
            overflow: TextOverflow.ellipsis,
          ),
        )
      )
    );
  }
}
