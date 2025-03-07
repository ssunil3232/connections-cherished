import 'package:connectionscherished/models/friends_model.dart';
import 'package:connectionscherished/services/user_service.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/buttons/journal/journal_connections_grid.dart';
import 'package:connectionscherished/widgets/navigation/top_nav_bar_widget.dart';
import 'package:connectionscherished/widgets/page_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

class JournalLanding extends StatefulWidget {
  const JournalLanding({super.key});
  @override
  JournalLandingState createState() => JournalLandingState();
}

class JournalLandingState extends State<JournalLanding> {
  final _userService = GetIt.I.get<UserService>();
  List<FriendModel> connections = [];
  
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
    getConnections();
    setState(() {
    });
  }

  Future<void> getConnections() async {
    try {
      connections = await _userService.getFriends();
      if (connections.isNotEmpty) {
        connections.sort((a, b) => b.calculatePriorityScore().compareTo(a.calculatePriorityScore()));
      }
      setState(() {});
    } catch (e) {
      Exception('Error fetching connections: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBarWidget(
        showBorder: false,
        height: 100.0,
        header: Text("Journals", style: GlobalStyles.textStyles.titleHeader),
        showBackButton: true,
      ),
      body: PagePadding(
        bottomPadding: GlobalStyles.spacingStates.spacing32,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: GlobalStyles.spacingStates.spacing40),
              RichText(
                text: TextSpan(
                  children:[
                    TextSpan(
                      text: "Every conversation holds meaning — whether it's a heartfelt exchange, a lesson learned, or a moment of joy.",
                      style: GlobalStyles.textStyles.textBody
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.only(left: GlobalStyles.spacingStates.spacing8),
                        child: SvgPicture.asset('assets/icons/smile_icon.svg', width: 24, height: 24),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: GlobalStyles.spacingStates.spacing16),
              Text(
                "This space allows you to jot down your reflections, feelings, and insights from your past interactions.",
                style: GlobalStyles.textStyles.textBody
              ),
              if(connections.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: GlobalStyles.spacingStates.spacing40),
                child: JournalsConnectionGrid(data: connections),
              ),
              if(connections.isEmpty)
              Spacer(),
              if(connections.isEmpty)
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: GlobalStyles.defaultTextBg,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: GlobalStyles.spacingStates.spacing44,
                        horizontal: GlobalStyles.spacingStates.spacing60
                      ),
                      child: Text(
                        "No connections yet!",
                        textAlign: TextAlign.center,
                        style: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.textSubtle)
                      )
                    ),
                    SizedBox(height: GlobalStyles.spacingStates.spacing40),
                    RichText(
                      text: TextSpan(
                        children:[
                          TextSpan(
                            text: 'Start by adding a ',
                            style: GlobalStyles.textStyles.textBody
                          ),
                          TextSpan(
                            text: 'connection!',
                            style: GlobalStyles.textStyles.textH3Varaint
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: GlobalStyles.spacingStates.spacing24),
                    Image.asset(
                      'assets/images/logo.png',
                      width: 146,
                      height: 140,
                    ),
                  ]
                )
              ),
              if(connections.isEmpty)
              Spacer(),
            ]
          )
        )
      
    );
  }
}